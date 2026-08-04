---
title: "Links for July 2026"
date: 2026-08-04T09:18:50+01:00
draft: false
---

- [Apps and programming: two accidental tyrannies](https://andymatuschak.org/tat)
  - Makes me want to take voice notes when reading
  - > a sequence of three or four words can uniquely identify pretty much any point in a book
  - [Interactive editable audio transcripts for Obsidian](https://github.com/andymatuschak/interactive-transcripts) is the released plugin
    - ["OpenAI Whisper"-compatible Automatic Speech Recognition (ASR) server using NVIDIA Parakeet Token-and-Duration Transducer (TDT) 0.6B Open Neural Network Exchange (ONNX). Super fast CPU/GPU transcriptions](https://github.com/achetronic/parakeet)
- [ØMQ - The Guide - Chapter 6 - The ZeroMQ Community](https://zguide.zeromq.org/docs/chapter6/) - I found the arguments for the use of forks and GPL curious.
- [Test-case Reducers Are Underappreciated Debugging Tools](https://tratt.net/laurie/blog/2026/test_case_reducers_are_underappreciated_debugging_tools.html) - an alternative approach to [test case minimization](https://matklad.github.io/2026/04/20/test-case-minimization.html), where instead of reducing the size of input data you are reducing the size of input code!
  - [Shrinkray is a modern multi-format test-case reducer](https://github.com/DRMacIver/shrinkray)
- [Casey Muratori – The Big OOPs: Anatomy of a Thirty-five-year Mistake – BSC 2025](https://www.youtube.com/watch?v=wo84LFzx5nI) - "OOP" here is taken to mean "compile-time hierarchy that matches the domain model". Seeing "we can inherit all objects from a linked list to be able to put all objects into linked lists" as the major motivation for inheritance is wild.
- [Odin, Wikipedia and Engagement Farming](https://katamari64.se/posts/2026/odin-wikipedia/) - why does Odin (a programming language) not have a Wikipedia article? TL;DR: notability and reliability of sources.
  - [Wikipedia:Articles for deletion/Zig (programming language)](https://en.wikipedia.org/wiki/Wikipedia:Articles_for_deletion/Zig_(programming_language)) is a good comparison point, [LWN](https://en.wikipedia.org/wiki/LWN.net) and [InfoWorld](https://en.wikipedia.org/wiki/InfoWorld) were the reliable sources for Zig, looks like there is still nothing similar for Odin.
- [What should a personal website be?](https://ratfactor.com/cards/personal-website) - this personal website is exemplary!
- [What is a “now page”?](https://nownownow.com/about)
  - > A /now page shares what you’d tell a friend you hadn’t seen in a year.
  - [A guide to common pages you can add to your website](https://slashpages.net/)
    - `/blank` is a must!
- [Local Reasoning for Global Properties](https://tratt.net/laurie/blog/2026/local_reasoning_for_global_properties.html)
  - > do we have a good example of programming language design that allows local reasoning to give us assurance about a surprising global property?
    - An example given is "Rust’s guarantee that concurrent code is free from data races"
    - [Memory safety](https://en.wikipedia.org/wiki/Memory_safety) is another case of this . I initially thought "Garbage Collection", but I do not think it gives any actual guarantees beyond memory safety.
  - > My experience is that AI – at least as it stands right now – often generates high-quality local (e.g. a function) chunks of code, but often struggles when asked to generate code that requires a global understanding of the program. The easiest way to see this is a proliferation of unnecessary defensive checks
    - [Dependent types](https://en.wikipedia.org/wiki/Dependent_type) are a possible solution here, a struct can carry a proof of relationships between its fields.
    - ```lean
      structure Violation where
        start_line : Nat
        end_line   : Nat
        ok         : start_line ≤ end_line
      ```
    - You can not construct a `Violation` without doing the check, and you can re-use that proof term when calling into functions that require `start_line ≤ end_line`.
- [Reflections on a decade of coding: On bad advice](https://www.scattered-thoughts.net/writing/on-bad-advice/)
  - > Programming practices are mostly tacit knowledge. Tacit knowledge isn't easy to share. An expert will relate some simple-sounding rule of thumb, but then grilling them on specific cases will quickly uncover a huge collection of exceptions and caveats that vary depending on the specific details of the situation. These are generated from many many past experiences and don't generalize well outside of the context of that body of experience.
    >
    > Trying to apply the rule of thumb without knowing all those details tends to result in failure. Phrases like "don't repeat yourself", "you aren't going to need it", "separation of concerns", "test-driven development" etc were originally produced from some body of valid experience, but then wildly over-generalized and over-applied without any of the original nuance.
    >
    > The way to convey tacit knowledge, if at all, is via the body of experiences that generated the rule. For this reason I find much more value in specific experience reports or in watching people actually working, as opposed to writing about general principles.
  - I've been reading "The Pragmatic Programmer" (ISBN 9780135957059), and a lot of the advice rings hollow, perhaps this decoupling from detailed experience is the reason. The book has anecdotes in support of some of the advice, but these anecdotes are short.
  - Perhaps "The Architecture of Open Source Applications" (ISBN 9781257638017) is a more useful kind of book to get better at programming.
- [Reflections on a decade of coding: Things unlearned](https://www.scattered-thoughts.net/writing/things-unlearned/)
  - > It's so easy to think that simple solutions exist. But if you look at the history of ideas that actually worked, they tend to only be simple from a distance. The closer you get, the more you notice that the working idea is surrounding by a huge number of almost identical ideas that don't work.
  - > Programming should be easy
    > A similar trap [...] often got me on a smaller scale. Whenever I ran up against something that was ugly or difficult, I would start looking for a simpler solution.
