+++
date = '2023-07-28T00:00:00+00:00'
draft = false
title = 'Learning geometry through formal proofs'
+++

Every once in a while I try to understand something in detail,
and often understanding something in detail
requires understanding a bunch of math.
I then go and try to understand the relevant math,
but that depends on yet more math I don't understand and so I give up.

The most recent iteration of this attempt at understanding something,
started in December 2022, is my attempt at understanding
"How Archimedes showed that π is approximately equal to 22/7" [^archimedes-pi]
.

It's 8 months later, I'm not even close, but I haven't given up yet!

[^archimedes-pi]: B., Damini D., and Abhishek Dhar. How Archimedes Showed That π Is Approximately Equal to 22/7. arXiv, 18 Aug. 2020. arXiv.org, <https://doi.org/10.48550/arXiv.2008.07995>.

## Suddenly, formal proof of Euclid's elements

Archimedes' approximation of pi uses perimeter of a regular polygon
inscribed around the circle as the upper bound on the circle's circumference.
Wait, how do I inscribe a regular polygon around the circle?

After a brief study of "straightedge and compass construction",
I settled on a great idea: Euclid's Elements has the answer, I should read that!
[^elements]

I hit my first roadblock right there in book 1 proposition 1.

```
With A as centre, and AB as radius, describe the circle BCD (Post. iii.).
With B as centre, and BA as radius, describe the circle ACE,
cutting the former circle in C.
```

Wait, there is no postulate for circle intersection,
how do I know that the two circles intersect?

By some accident,
instead of stumbling into Hilbert's axioms for Euclidean geometry,
I found my answer in "Proof-checking Euclid". [^proof-checking-euclid]

```
Nevertheless there are flaws in Euclid,
and we want to discuss their nature by way of introduction to the subject.
The first gap occurs in the first proposition, I.1,
in which Euclid proves the existence of an equilateral triangle
with a given side,
by constructing the third vertex as the intersection point of two circles.
But why do those two circles intersect?
Euclid cites neither an axiom nor a postulate nor a common notion.
This gap is filled by adding the “circle–circle” axiom,
according to which if circle C has a point inside circle K,
and also a point outside circle K, then there is a point lying on both C and K.
```

Given my experience with stumbling over yet more math I don't understand,
I found formal machine-verified proofs of Euclid's Elements
a breath of fresh air, everything that was needed for the proof was right there!
I could start at the very bottom of geometry and learn my way up.

[^elements]: first 6 books translated to English can be found at Project Gutenberg - <https://www.gutenberg.org/ebooks/21076>

[^proof-checking-euclid]: Beeson, Michael, et al. ‘Proof-Checking Euclid’. Annals of Mathematics and Artificial Intelligence, vol. 85, no. 2–4, Apr. 2019, pp. 213–57. DOI.org (Crossref), <https://doi.org/10.1007/s10472-018-9606-x>.

## GeoCoq

GeoCoq[^geocoq-repo] is a project that implements
the "Proof-checking Euclid" paper (among other things),
although some details are different (for example, proposition proof order).
I found that implementation easiest to follow
(compared to the PHP version[^proof-checking-php]),
but following it definitely wasn't easy.

Proofs in Coq have "context",
you prove a lemma by starting with some hypotheses,
then you derive an additional hypothesis
using axioms or previously proven lemmas,
add the derived hypothesis to the context,
repeat until you eventually prove what you wanted to prove.
There is one problem though,
Coq allows you to automate yourself out of specifying which hypotheses
are used in which lemmas to derive which new hypotheses.
You end up with proofs that are difficult to follow
if you don't already know what's happening,
which isn't conductive to learning.

So I set out to rewrite all the Euclid's Elements book 1 proofs in GeoCoq
such that I could follow how they unfold.

[^geocoq-repo]: <https://github.com/GeoCoq/GeoCoq>

[^proof-checking-php]: <http://www.michaelbeeson.com/research/CheckEuclid/index.php>

## Where I am now

I have now translated 33 out of 48 propositions (and their dependencies)
to something that I consider more readable.
You can find the results of that work in
<https://github.com/blin/proof-checking-euclid/> .

Why stop at proposition 33?
There is this passage in chapter 2 of "The Road to Reality" by Roger Penrose:

```
Take three equal line segments AB, BC, and CD,
where ABC and BCD are right angles,
D and A being on the same side of the line BC, as in Fig. 2.7.
The question arises: is AD the same length as the other three segments?
Moreover, are the angles DAB and CDA also right angles?
```

Yes and yes.
Proposition 33 was the latest proposition I needed
to answer these questions[^road-to-reality-proof].

This is a milestone unrelated to approximation of π,
but it's a somewhat interesting result that I managed to derive myself
and I need a break from translation.

Now I want to focus on memorizing the proofs of propositions
up to proposition 33.
Memory and understanding are intertwined,
but I will write more about this once I can recall the proof of proposition 33.

[^road-to-reality-proof]: <https://github.com/blin/proof-checking-euclid/blob/master/lemma_road_to_reality_2_7.v>
