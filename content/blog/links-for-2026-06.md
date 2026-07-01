---
title: "Links for June 2026"
date: 2026-07-01T09:46:47+01:00
draft: false
---

- [Monty](https://github.com/pydantic/monty) - "A minimal, secure Python interpreter written in Rust for use by AI."
  - The AI part is of no interest to me, but an embedded Python with resource isolation is very much of interest.
  - [Via simonw](https://github.com/simonw/research/tree/main/monty-investigation)
- [Ten years of \[It's ok to say what's ok\]](https://gilest.org/notes/2026/ok/) - this seems to be a lovely practice! It's okay to appreciate things.
- [Working in the open ≠ comms](https://gilest.org/notes/2026/open/)
  - > Comms is about broadcasting achievements and results. It’s an act of promotion.
  - > Working in the open is about making work visible. It’s an act of sharing.
  - This is something to look out for in my own writing: what is my motivation?
- [The Interesting Conferences](https://interesting.blot.im/) - 10 minute talks without a set theme, this sounds wonderful, I wish I found out about them before their 2026 conference passed.
- [Boring Tiny Tools](https://vaughntan.org/boringtinytools)
  - > Build software that limits itself to replacing only parts of work that require no discretion or judgment calls
- [CSCI 1377: Tools for Thought - S26](https://cel.cs.brown.edu/csci-1377-s26/) - this is a course I'd love to take, or at least go through the list of reading material.
- [PEP 831 – Frame Pointers Everywhere: Enabling System-Level Observability for Python](https://peps.python.org/pep-0831/) - getting stack traces for Python with frame pointers in Python is near-trivial, although there are no line numbers in symbolisation via [Python support for the perf map compatible profilers](https://docs.python.org/3.15/howto/perf_profiling.html)
- [\[Python\] Remote debugging attachment protocol](https://docs.python.org/3.14/howto/remote_debugging.html) - this document covers "the easiest" way to get Python 3.13+ stack traces without "frame pointers with perf maps". Before 3.13 it is even more difficult.
  - TL;DR is: parse the interpreter ELF, get interpreter state structure memory offset, retrieve interpreter state structure from process memory using the offset, parse out the stacks from that.
    - `_Py_DebugOffsets` struct located at the top of interpreter state struct, that was added in 3.13, is what makes this process easier
  - This is what [pystack](https://github.com/bloomberg/pystack) does in userspace and what [strobelight](https://github.com/facebookincubator/strobelight-libs/tree/main/strobelight/bpf_lib/python/pystacks) does in eBPF.
