---
title: "Links for May 2026"
date: 2026-06-01T20:34:34+01:00
draft: false
---

I always liked the "assortment of links" type of blog post
(for example,
[Links for April 2026 from Astral Codex Ten](https://www.astralcodexten.com/p/links-for-april-2026))
let's see if I can maintain this long term!

- [256 Lines or Less: Test Case Minimization](https://matklad.github.io/2026/04/20/test-case-minimization.html) - finite RNG for [[Property-Based Testing]], seed + size determine a specific run, size can be automatically minimized
- [Faster Go maps with Swiss Tables](https://go.dev/blog/swisstable) - Swiss tables but for go, with amortized resizing via https://en.wikipedia.org/wiki/Extendible_hashing .
- [Learning Software Architecture](https://matklad.github.io/2026/05/12/software-architecture.html) - collection of links for "Learning Software Architecture", seems like a treasure trove of sources I haven't seen cited before
  - [TigerBeetle code style guide](https://github.com/tigerbeetle/tigerbeetle/blob/0.17.4/docs/TIGER_STYLE.md) - curious collection of recommendations, especially when viewed from a less performance oriented perspective (like that of a Python programmer)
    - I really like the "all loops and all queues must have a fixed upper bound to prevent infinite loops or tail latency spikes", this pattern is known as "fuel" in theorem proving land, see [Software Foundations: Verified Functional Algorithms](https://softwarefoundations.cis.upenn.edu/vfa-current/Selection.html).
  - [Boundaries - A talk by Gary Bernhardt from SCNA 2012](https://www.destroyallsoftware.com/talks/boundaries) - many points similar to [[Testing Without Mocks: A Pattern Language]], nothing seems to stand out.
  - [How to Test](https://matklad.github.io/2021/05/31/how-to-test.html) a bunch of testing ideas that I already appreciated from other sources, but all collected into one.
    - > Neural Network Test - Can you re-use the test suite if your entire software is replaced with an opaque neural network?
    - [Testing at the boundaries - by Ted Kaminski](https://www.tedinski.com/2019/03/19/testing-at-the-boundaries.html)
- [Developing creative identity](https://michaelnotebook.com/dci/) - musings on "who am I (creatively)?" with "I'm not a writer. I'm an explorer and researcher who also writes" as the final answer.
  - The core of a the text is the discussion of what writing is and who writers are.
  - > writing to discover
  - > for much of the Origin, Darwin writes beautifully, holding and developing the reader's interest. And for much of the Origin he is tedious, long-winded, even just plain boring. Why does a good prose stylist so often slip into tedium?
    - > there is a lot about pigeons in the Origin. It's high quality evidence and argument, but even someone who loved pigeons might find it tedious! More broadly: often Darwin needs evidence for some assertion in the form of a long list of facts. And so long lists of facts we get. Often his best arguments are long and detailed and involve hedging and special cases and identification of weaknesses. And so they go in too.
    - > The tension here is that what is interesting is not always true; what is true is not always interesting. And this applies not only to the truth, but also to convincing evidence and to good explanations. Darwin prioritizes truth, evidence, and explanation, and that strongly shapes his writing.
- [Half A Month Of Consolation Writing Advice](https://www.astralcodexten.com/p/half-a-month-of-consolation-writing)
  - > Against microdishonesty
    - > The English language hates the slightest whiff of dishonesty, even levels so small you wouldn’t naturally notice them yourself. It punishes you by making your writing worse.
    - I've noticed this when writing [Output Tracking and Passing a Struct by Value in Go](https://evgenii-petrov.net/blog/output-tracking-and-golang-struct-pass-by-value/), there was a result I couldn't explain and I wanted to brush it off as it was irrelevant to the point I was trying to make, but brushing it off felt dishonest, so I ended up doing additional research and supplying it in an appendix.
- [Jujutsu megamerges for fun and profit](https://isaaccorbrey.com/notes/jujutsu-megamerges-for-fun-and-profit)
  - Megamerges might make it worth it to switching over to jj from [sapling](https://sapling-scm.com/).
  - I've been using sapling at work since the first public release, and I'm overall happy, except for exactly the problem that megamerges solve -- splitting off unrelated features into separate stacks, while still having them in the working copy is basically not a thing you can do in sapling.
  - Recently I had 4 independent changes which I had to linearise in an arbitrary order to have the sum of the changes in the working copy, a megamerge might be a nice alternative.
- [Better generated branch names with jj](https://ddbeck.com/notes/jj-git-push-bookmark-template/)
  - Might come in handy if I switch to jj from sapling.
  - When sapling creates github PRs (which jj does not do), it first creates a PR, gets the PR id, then creates a `pr${pr_id}` branch which I find very convenient!
  - Given that I'll need to re-implement sapling PR handling code myself, I'll probably go for a simpler branch naming approach, and what is proposed in the post looks neat.
- [bijou64](https://www.inkandswitch.com/tangents/bijou64/) - introduction to a new variable length integer encoding (varint) with a discussion of canonical representation of varints and performance comparison with a bunch of other varint encodings.
  - Protobufs use unsigned [LEB128](https://en.wikipedia.org/wiki/LEB128)
  - The [rust implementation of decode](https://github.com/inkandswitch/bijou/blob/ae834fe465d8cea5b506a8b69f90bcd236f7b984/bijou64/src/lib.rs#L459) is beautifully straightforward.

