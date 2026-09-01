---
title: "Links for August 2026"
date: 2026-09-01T08:54:32+01:00
draft: false
---

It has been a difficult month, my capacity to write useful notes for the links
I want to share is diminished, yet I don't want to abandon this practice,
so sometimes I'll just share links with no descriptions.
The only signal that you get is that I found these links cool or useful
or both.


- [Contra Ptacek's Terrible Article On AI](https://ludic.mataroa.blog/blog/contra-ptaceks-terrible-article-on-ai/)
  - I found the "can I call you (Thomas|Tom|Tomothy|Tomtom|Tomahawk Missile|Tommy Gun)?" bit hilarious, but also I just like reading LLM takedowns 🤷 .
- [Ludic's Guide To Getting Software Engineering Jobs](https://ludic.mataroa.blog/blog/ludics-guide-to-getting-software-engineering-jobs)
  - Looks like I've been lucky enough to avoid "The First Job Market", but I also never got to "know that if your business explodes, or the cool non-profit you find fires you, or if a new boss comes in and abuses you, you'll know deep down that you can walk right out that door and tell them to get fucked".
- [Bevy's Sixth Birthday](https://bevy.org/news/bevys-sixth-birthday/)
  - It is curious to see a video game engine in a "pre visual editor" stage. Having tried Godot's "visual editor heavy" tutorial, not having a visual editor at all is enticing.
- [Moving away from Tailwind, and learning to structure my CSS](https://jvns.ca/blog/2026/05/15/moving-away-from-tailwind--and-learning-to-structure-my-css-/)
  - CSS is something I always wanted to learn, but never got around too, this post is one more enticement, and it has some good suggestions and references.
  - Insired by this post I finally looked up a way to remove the bottom margin on the *last* `<p>` inside `<blockquote>`
  - [:last-of-type CSS pseudo-class](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/:last-of-type)
- [The Burning Wheel](https://www.burningwheel.com/collections/burning-wheel)
  - I have not played the Burning Wheel, but the rulebook is really cool! The elven Grief mechanic and dwarven Greed mechanic sound like a great way to make races narratively distinct!
- [Composition Root](https://blog.ploeh.dk/2011/07/28/CompositionRoot/)
  - I got the idea of "just compose everything in main" independently, but didn't have a catchy name for it, glad it exists! It also clashes with the "Parameterless Instantiation" pattern in [[Testing Without Mocks: A Pattern Language]], which never made sense to me for production constructors. Parameterless test constructors are still probably a good idea.
- [Am I the problem? Interviewing another team to find out.](https://www.macchaffee.com/blog/2026/am-i-the-problem/)
  - > Multiple people on the ngrok infra team cited their good rapport with each other, and also mentioned their social meetings, such as building tier lists together or playing GeoGuessr cooperatively.
  - > Burnout is the combination of resentment, exhaustion, shame, and frustration that make us lose connection to pleasure and passion in the work and instead encounter difficult feelings like avoidance, compulsion, control, and anxiety.
    >
    > Burnout is created or worsened when we feel disconnected from others, mistreated, misunderstood, ashamed, overburdened, obsessed with outcomes, perfectionist, or controlling. Burnout is prevented or lessened when we feel connected to others, when there is transparency in how we work together, when we can rest as needed, when we feel appreciated by the group, and when we have skills for giving and receiving feedback.
    - Quoted from [Mutual Aid by Dean Spade](https://search.worldcat.org/title/1198450425).
- [The Typestate Pattern in Rust](https://cliffle.com/blog/rust-typestate/)
  - I was recently thinking about this pattern and how it might work in Python, but alas Rust's move semantics are what make the pattern reliable and `impl Type<State>` is what make it less cumbersome than implementing separate types (and coming up with names for separate types!).
- [This is a reminder](https://gilest.org/notes/2026/reminder/)
  - [2026 European heatwaves](https://en.wikipedia.org/wiki/2026_European_heatwaves) is the context
- [Poem by Caitlin Seida: Hope Is Not a Bird, Emily, It’s a Sewer Rat](https://ratfactor.com/cards/poem-hope-is-a-sewer-rat-by-seida)
- [Down II-IV — Håkon Anton Fagerås](https://fageras.com/down/)
- [Postgres as an isolation reference model](https://rednafi.com/system/pg-isolation-ref/)
- [Supervised fire-and-forget in Go](https://rednafi.com/go/supervised-fire-and-forget/)
- [Request coalescing with Go singleflight](https://rednafi.com/go/request-coalescing/)
- [Reading your own writes with WAIT FOR LSN in Postgres 19](https://rednafi.com/system/pg-wait-for-lsn/)
- [Wikibase Snaks](https://www.mediawiki.org/wiki/Wikibase/DataModel#Snaks)
  - [Some of the libraries recommended for use with Wikidata](https://www.wikidata.org/wiki/Wikidata:Tools/For_programmers#Python_libraries) have this notion of [Snaks](https://wikibaseintegrator.readthedocs.io/en/stable/wikibaseintegrator.models.snaks.html).
  - In the past I used SPARQL directly and Snaks didn't come up.
- [Wikibase DataModel Primer](https://www.mediawiki.org/wiki/Wikibase/DataModel/Primer)
