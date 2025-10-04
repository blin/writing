+++
date = '2025-07-18T15:23:50+00:00'
draft = false
title = 'Library Note Pattern'
+++

Every once in a while I need to write a comment in one place
and then refer to that comment from other places.

Turns out there is now a language-independent tool that helps
to use this pattern -
[`tagref`](https://github.com/stepchowfun/tagref)!

`tagref` claims to be inspired by the Glasgow Haskell Compiler (GHC),
and specifically by their "Notes" system
described in
[The Architecture of Open Source Applications](https://aosabook.org/en/)
specifically chapter 5 section 6.

[GHC Style Guide](https://gitlab.haskell.org/ghc/ghc/-/wikis/commentary/coding-style#2-using-notes)
[(a)](https://web.archive.org/web/20200618233720/https://gitlab.haskell.org/ghc/ghc/-/wikis/commentary/coding-style#comments-in-the-source-code)
also describes this pattern.
Version of the style guide as of 2025-07-18 has exactly the same text as the book mentioned above.
See archived link from 2020 for a slightly different phrasing.

The same pattern is also used in the Lean (proof assistant) ecosystem,
where it is referred to as "library note".
See the [definition of the pattern](https://github.com/leanprover-community/batteries/blob/main/Batteries/Util/LibraryNote.lean)
and the [use of the pattern](https://github.com/search?q=repo%3Aleanprover-community%2Fmathlib4+library_note&type=code).
