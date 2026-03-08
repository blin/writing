---
title: "Output Tracking and Passing a Struct by Value in Go"
date: 2026-03-28T10:29:00Z
draft: false
---

I've been playing around with the [Output Tracking] pattern,
TL;DR of which is
"for every event you want to observe in tests, do an `emitEvent` call".

[Output Tracking]: https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#output-tracking

Here is a little scenario:
I need to receive "records" over the network,
accumulate them in memory and periodically write them in bulk to some sort of persistent storage.
It is useful to know when the writes to persistent storage start and end,
as well as some stats on what was being written and how long it took.

Without output tracking,
I might implement the "bulk write to storage" part of this scenario like so:

```go
func (c *Chunker) Flush(records []*Record) {
	recordsCount := len(records)
	recordsBytes := 0
	for _, r := range records {
		s := r.Size()
		recordsBytes += s
	}

	slog.Info("flush started", "recordsCount", recordsCount, "recordsBytes", recordsBytes)
	start := time.Now()
	// write to storage
	elapsed := time.Since(start)
	slog.Info("flush finished", "recordsCount", recordsCount, "recordsBytes", recordsBytes, "elapsed", elapsed)
}
```

With output tracking, I might implement the same method like so
(see full code in [Appendix A](#appendix-a)):

```go
[...]

func (c *Chunker) Flush(records []*Record) {
	recordsCount := len(records)
	recordsBytes := 0
	for _, r := range records {
		recordsBytes += r.Size()
	}

	c.emitEvent(FlushStarted{recordsCount: recordsCount, recordsBytes: recordsBytes})
	start := time.Now()
	// write to storage
	elapsed := time.Since(start)
	c.emitEvent(FlushFinished{recordsCount: recordsCount, recordsBytes: recordsBytes, elapsed: elapsed})
}

func (c *Chunker) emitEvent(e ChunkerEvent) {
	if c.tracker != nil {
		c.tracker.AddEvent(e)
	}
	switch e := e.(type) {
	case FlushStarted:
		slog.Info("flush started", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes)
	case FlushFinished:
		slog.Info("flush finished", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes, "elapsed", e.elapsed)
	default:
		panic(fmt.Sprintf("unexpected ChunkerEvent: %#v", e))
	}
}

func main() {
	chunker := &Chunker{}
	tracker := chunker.InstallTracker()
	chunker.Flush([]*Record{{Payload: []byte("rec1")}, {Payload: []byte("rec2")}})
	events := tracker.GetEvents()
	fmt.Printf("%#v\n", events)
}
```

Which produces the following output when run:

```text
2026/03/15 16:34:43 INFO flush started recordsCount=2 recordsBytes=8
2026/03/15 16:34:43 INFO flush finished recordsCount=2 recordsBytes=8 elapsed=80ns
[]main.ChunkerEvent{main.FlushStarted{recordsCount:2, recordsBytes:8}, main.FlushFinished{recordsCount:2, recordsBytes:8, elapsed:80}}
```

Output tracking makes it very easy
to assert the expected sequence of events in tests[^output-tracking-benefits],
but what is the performance cost of this implementation?

[^output-tracking-benefits]: In addition,
  if I care enough about an event to check for it in tests,
  I probably will benefit from adding production telemetry for it.
  The converse is also true,
  if I care enough about an event to add production telemetry for it,
  I probably will benefit from checking for it in tests.

## Passing a struct by interface value

According to [Golang FAQ](https://go.dev/doc/faq#pass_by_value)

> [...] everything in Go is passed by value.
> That is, a function always gets a copy of the thing being passed,
> as if there were an assignment statement assigning the value to the parameter.
> For instance, passing an int value to a function makes a copy of the int,
> and passing a pointer value makes a copy of the pointer, but not the data it points to. [...]
>
> Copying an interface value makes a copy of the thing stored in the interface value.
> If the interface value holds a struct, copying the interface value makes a copy of the struct.
> If the interface value holds a pointer, copying the interface value makes a copy of the pointer,
> but again not the data it points to.

But what are the _mechanics_ of "makes a copy of the struct"?
To answer that question I looked at the [Go Assembler output](https://go.dev/doc/asm).

Using `go tool compile -S` is a bit difficult in the presence of imports,
so it is easier to use `go build` followed by `go tool objdump`.

```text
$ go build -o executable ./cmd/interface-value/ && go tool objdump -s 'main.*Flush' ./executable 2>&1 | grep main.go:69
  main.go:69            0x4d8b20                48894c2438              MOVQ CX, 0x38(SP)
  main.go:69            0x4d8b25                4889742440              MOVQ SI, 0x40(SP)
  main.go:69            0x4d8b2a                488d050fec0100          LEAQ 0x1ec0f(IP), AX
  main.go:69            0x4d8b31                488d5c2438              LEAQ 0x38(SP), BX
  main.go:69            0x4d8b36                e80529f4ff              CALL runtime.convTnoptr(SB)
  main.go:69            0x4d8b3b                488d1dd6c80300          LEAQ go:itab.main.FlushStarted,main.ChunkerEvent(SB), BX
  main.go:69            0x4d8b42                4889c1                  MOVQ AX, CX
  main.go:69            0x4d8b45                488b442458              MOVQ 0x58(SP), AX
  main.go:69            0x4d8b4a                e891000000              CALL main.(*Chunker).emitEvent(SB)
```

The output is filtered to just

```go
c.emitEvent(FlushStarted{recordsCount: recordsCount, recordsBytes: recordsBytes})
```

Before this line:

* The `CX` register is populated with the `recordsCount` value
* The `SI` register is populated with the `recordsBytes` value
* `Chunker` pointer receiver is placed on the stack at `0x58(SP)`.

On this line:

1. `recordsCount` and `recordsBytes` are placed on the stack in the `FlushStarted` struct order,
1. The pointer to the struct type is placed in register `AX`.
   In this specific case the struct type is mostly used for the size of the struct.
1. The pointer to the beginning of the struct on the stack is placed in the `BX` register.
1. `runtime.convTnoptr(AX, BX)` is called, the space for `FlushStarted` is allocated on the heap,
   then the data is `memmove`d[^memmove] to the heap and
   the pointer to the heap is returned in register `AX`.
1. The pointer to the `ChunkerEvent` "interface table"[^itab] for `FlushStarted`
   is placed in register `BX`.
1. The pointer returned by `convTnoptr` is placed in register `CX`.
1. The pointer to the `Chunker` is placed in register `AX`.
1. `emitEvent(AX, {BX, CX})` is called.

[^memmove]: `memmove` is implemented in assembly for each supported instruction set,
  and it roughly boils down to
  "move bytes from memory to register, from register to memory, word by word", see
  [runtime/memmove_amd64.s](https://go.googlesource.com/go/+/refs/tags/go1.26.1/src/runtime/memmove_amd64.s).

[^itab]: Interface table is basically `(*InterfaceType, *ImplementingType)`, see
  [abi/iface.go](https://go.googlesource.com/go/+/refs/tags/go1.26.1/src/internal/abi/iface.go).

To sum it up: the data is spilled from registers to the stack,
some space is allocated on the heap,
data is copied from the stack to the heap word by word,
then the pointer to the heap is placed in a register where the callee can find it.

Here is a benchmark I used to compare the performance of
"no output tracking" and "output tracking with pass by interface value":

```go
package main

import (
	"io"
	"log/slog"
	"testing"
)

func BenchmarkFlushNoTracker(b *testing.B) {
	slog.SetDefault(slog.New(slog.NewTextHandler(io.Discard, nil)))
	records := []*Record{
		{Payload: []byte("rec1")},
		{Payload: []byte("rec2")},
	}
	c := &Chunker{}
	for b.Loop() {
		c.Flush(records)
	}
}
```

And here are the results[^results-but-not-really]:

[^results-but-not-really]: The no-output-tracking result here is for a slightly modified code
  see [Appendix B](#appendix-b).

```text
$ go test ./cmd/no-output-tracking/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/no-output-tracking
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        983547              1212 ns/op               0 B/op          0 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/no-output-tracking   1.197s

$ go test ./cmd/interface-value/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/interface-value
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        904065              1277 ns/op              40 B/op          2 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/interface-value      1.160s
```

On this CPU, with no CPU/memory contention, during this run,
the cost of "output tracking with pass by interface value"
is 32.5 nanoseconds per event
(`(1277-1212)/2`, there are two events per benchmark loop).

I think I might be able to bring the cost down a bit if I can avoid
allocating every event on the heap.

## Passing a struct by generic value

Since 1.18 Go has support for generics, so potentially I could just replace

```go
func (c *Chunker) emitEvent(e ChunkerEvent)
```

with

```go
func (c *Chunker) emitEvent[T ChunkerEvent](e T)
```

thus passing in the struct as is, without constructing an interface value.

There are 2 little snags here:

1. As of Go 1.26
   [there are no generic methods in Go](https://github.com/golang/website/blob/cbab1cbaa36382cddee72e9d5eaeb956517f1c37/_content/doc/faq.md?plain=1#L1669),
   but [the proposal to add generic methods was approved](https://github.com/golang/go/issues/77273#issuecomment-3962618141)
   and it will be implemented in a later release.
2. [Type assertions on type parameters are not permitted](https://go.googlesource.com/proposal/+/master/design/43651-type-parameters.md#why-not-permit-type-assertions-on-values-whose-type-is-a-type-parameter)

Which are somewhat easy to overcome by turning `emitEvent` into a function instead of a method and
by using a `processEvent` interface method
that accepts `*Chunker`[^why-process-event-chunker] instead of a type assertion, like so:

[^why-process-event-chunker]: Why make `processEvent` accept `*Chunker`?
  The code shown is trivialised,
  in practice I would use a non-global logger/metrics-publisher
  that are only available through `*Chunker`.

```go
func (c *Chunker) Flush(records []*Record) {
	recordsCount := len(records)
	recordsBytes := 0
	for _, r := range records {
		recordsBytes += r.Size()
	}

	emitEvent(c, FlushStarted{recordsCount: recordsCount, recordsBytes: recordsBytes})
	start := time.Now()
	// write to storage
	elapsed := time.Since(start)
	emitEvent(c, FlushFinished{recordsCount: recordsCount, recordsBytes: recordsBytes, elapsed: elapsed})
}

func emitEvent[T ChunkerEvent](c *Chunker, e T) {
	if c.tracker != nil {
		c.tracker.AddEvent(e)
	}
	e.processEvent(c)
}

func (e FlushStarted) processEvent(c *Chunker) {
	slog.Info("flush started", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes)
}

func (e FlushFinished) processEvent(c *Chunker) {
	slog.Info("flush finished", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes, "elapsed", e.elapsed)
}
```

Here is the relevant assembly:

```text
$ go build -o executable ./cmd/interface-generic/ && go tool objdump -s 'main.*Flush' ./executable 2>&1 | grep main.go:69
  main.go:69            0x4d8b1b                4889c3                  MOVQ AX, BX
  main.go:69            0x4d8b1e                4889f7                  MOVQ SI, DI
  main.go:69            0x4d8b21                488d0518cb0300          LEAQ main..dict.emitEvent[main.FlushStarted](SB), AX
  main.go:69            0x4d8b28                e8f3050000              CALL main.emitEvent[go.shape.struct { main.recordsCount int; main.recordsBytes int }](SB)
```

The output is filtered to just

```go
emitEvent(c, FlushStarted{recordsCount: recordsCount, recordsBytes: recordsBytes})
```

Before this line:

* The `AX` register is populated with the `Chunker` pointer receiver
* The `CX` register is populated with the `recordsCount` value
* The `SI` register is populated with the `recordsBytes` value

On this line:

1. The pointer to the `Chunker` is placed in register `BX`.
1. `recordsBytes` is placed in register `DI`, `recordsCount` was already placed in register `CX`.
1. [gcshape dictionary] [^gcshape] for `FlushStarted` struct is placed in register `AX`.
1. `emitEvent(AX, BX, {CX, DI})` is called.

[gcshape dictionary]: https://go.googlesource.com/proposal/+/refs/heads/master/design/generics-implementation-dictionaries-go1.18.md

[^gcshape]: I am now mentally replacing "gcshape" with "registers and instructions shape".
  A generic function that accepts a struct can use the same registers and instructions
  for all structs with the same layout,
  but to call methods on these structs the generic function needs to know where those methods are,
  this information is included in the shape dictionary.

And that's it! The struct is passed to the callee via registers and
there are no heap allocations.

Running the same benchmark again:

```text
$ go test ./cmd/no-output-tracking/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/no-output-tracking
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        986472              1195 ns/op               0 B/op          0 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/no-output-tracking   1.184s

$ go test ./cmd/interface-generic/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/interface-generic
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        967821              1209 ns/op               0 B/op          0 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/interface-generic    1.175s

$ go test ./cmd/interface-value/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/interface-value
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        914126              1268 ns/op              40 B/op          2 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/interface-value      1.165s
```

On this CPU, with no CPU/memory contention, during this run,
the cost of "output tracking with pass by generic value"
is about 7 nanoseconds per event (`(1209-1195)/2`).

With the assembly being this straightforward and cost being this close to baseline
I will default to using output tracking with pass by generic value.
If ever I need to claw back some precious nanoseconds on a hot path,
I will let the profiler tell me whether output tracking is what I need to cut.

## Appendix A

```go
package main

import (
	"fmt"
	"log/slog"
	"time"
)

type Tracker[T any] struct {
	events []T
}

func NewTracker[T any]() *Tracker[T] {
	return &Tracker[T]{events: make([]T, 0)}
}

func (t *Tracker[T]) AddEvent(e T) {
	t.events = append(t.events, e)
}

func (t *Tracker[T]) GetEvents() []T {
	return t.events
}


type Record struct {
	Payload []byte
}

func (r *Record) Size() int {
	return len(r.Payload)
}

type ChunkerEvent interface {
	isChunkerEvent()
}

type FlushStarted struct {
	recordsCount int
	recordsBytes int
}

func (e FlushStarted) isChunkerEvent() {}

type FlushFinished struct {
	recordsCount int
	recordsBytes int
	elapsed      time.Duration
}

func (e FlushFinished) isChunkerEvent() {}

type Chunker struct {
	tracker *Tracker[ChunkerEvent]
}

func (c *Chunker) InstallTracker() *Tracker[ChunkerEvent] {
	c.tracker = NewTracker[ChunkerEvent]()
	return c.tracker
}

func (c *Chunker) Flush(records []*Record) {
	recordsCount := len(records)
	recordsBytes := 0
	for _, r := range records {
		recordsBytes += r.Size()
	}

	c.emitEvent(FlushStarted{recordsCount: recordsCount, recordsBytes: recordsBytes})
	start := time.Now()
	// write to storage
	elapsed := time.Since(start)
	c.emitEvent(FlushFinished{recordsCount: recordsCount, recordsBytes: recordsBytes, elapsed: elapsed})
}

func (c *Chunker) emitEvent(e ChunkerEvent) {
	if c.tracker != nil {
		c.tracker.AddEvent(e)
	}
	switch e := e.(type) {
	case FlushStarted:
		slog.Info("flush started", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes)
	case FlushFinished:
		slog.Info("flush finished", "recordsCount", e.recordsCount, "recordsBytes", e.recordsBytes, "elapsed", e.elapsed)
	default:
		panic(fmt.Sprintf("unexpected ChunkerEvent: %#v", e))
	}
}

func main() {
	chunker := &Chunker{}
	tracker := chunker.InstallTracker()
	chunker.Flush([]*Record{{Payload: []byte("rec1")}, {Payload: []byte("rec2")}})
	events := tracker.GetEvents()
	fmt.Printf("%#v\n", events)
}
```

## Appendix B

Here is what I saw when I ran the benchmark for the first time:

```text
$ go test ./cmd/no-output-tracking/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/no-output-tracking
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        832208              1403 ns/op               0 B/op          0 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/no-output-tracking   1.172s

$ go test ./cmd/interface-value/ -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/interface-value
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        911614              1279 ns/op              40 B/op          2 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/interface-value      1.171s

```

Huh? No output tracking is slower?

Turns out[^no-slog-assembly] that compiler was inlining `slog.Info` which was
making the "no output tracking" implementation slower,
which is confirmed by running the same benchmark with inlining disabled[^gcflags]:

[^no-slog-assembly]: The assembly for Flush with inlined `slog.Info` is wild,
  I'll skip going over it in this post.

[^gcflags]: `-gcflags=-l` is what tells the compiler to disable inlining.
  Whenever I see "gcflags" I think "garbage collection flags",
  but apparently the name of the standard go compiler is
  ["gc"](https://go.dev/doc/faq#Do_Go_programs_link_with_Cpp_programs),
  so "gcflags" are just "compiler flags".

```text
$ go test ./cmd/no-output-tracking/ -gcflags=-l -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/no-output-tracking
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        958992              1241 ns/op               0 B/op          0 allocs/op
PASS
ok      github.com/blin/go-lab/cmd/no-output-tracking   1.195s

$ go test ./cmd/interface-value/ -gcflags=-l -bench=. -benchtime=1s -benchmem
goos: linux
goarch: amd64
pkg: github.com/blin/go-lab/cmd/interface-value
cpu: AMD Ryzen 7 7800X3D 8-Core Processor
BenchmarkFlushNoTracker-16        852105              1312 ns/op              40 B/op          2 allocs/op
PASS
```

I moved `slog.Info` calls into trivial function wrappers:

```go
func logFlushStarted(recordsCount int, recordsBytes int) {
	slog.Info("flush started", "recordsCount", recordsCount, "recordsBytes", recordsBytes)
}

func logFlushFinished(recordsCount int, recordsBytes int, elapsed time.Duration) {
	slog.Info("flush finished", "recordsCount", recordsCount, "recordsBytes", recordsBytes, "elapsed", elapsed)
}
```

With that change, `slog.Info` was no longer inlined into `Flush`,
and the benchmarks turned out as shown outside this appendix.
