---
title: "Notes on Working Effectively with Legacy Code"
date: 2025-11-24T08:13:18Z
draft: false
---

Same as in [Notes on How to Take Smart Notes]({{< relref "notes-on-how-to-take-smart-notes.md" >}}),
below are my notes from reading "Working Effectively with Legacy Code".

The notes are in the [Logseq](https://github.com/logseq/logseq) format:

- Text in double square braces(like `[[Test scope]]`) links to other notes I have,
  you don’t get to see them, sorry.
- Nodes marked with `#card` are spaced repetition card prompts,
  all children of a `#card` node are the expected response.

<!--more-->

## Notes

- Feathers, Michael C. Working Effectively with Legacy Code. Prentice Hall Professional Technical Reference, 2005.
  - ISBN-13 -> 9780132931748
- In what year was "Working Effectively with Legacy Code" first published? #card
  - 2004
- Summary
  - I first read this book in 2011, when my primary programming language was Java, and thought it was amazing. Re-reading it in 2025 I think it is a great book.
  - Some of the advice in the book now seems timeless, specifically when and how to break code apart for "sensing and separation".
  - Other parts of the book feel irrelevant, if you are lucky enough to not need to deal with inheritance (shout out to Go, Rust, typed functional Python, OCaml and the like). The book was written by someone deep in Java EE world in 2004, and that shows throughout the book, there are a lot of patterns that are only relevant in the OOP with inheritance paradigm. To the author's credit, they do point out that inheritance is a source of subtle bugs on more than one occasion.
- Metaphors
  - Seam, see "Chapter 4: The Seam Model"
    - From the book
      - > A **seam** is a place where you can alter behavior in your program without editing in that place.
      - I wonder if <https://en.wikipedia.org/wiki/JBoss_Seam> has something to do with the choice of name.
    - From wikipedia
      - >In sewing, seam is the join where two or more layers of fabric, leather, or other materials are held together with stitches
      - Metallurgy and geology seams are even less relevant!
    - This is NOT a great metaphor!
      - It is not at all common to undo stitches to change behavior! One might undo stitches to replace a liner in a coat if that liner got torn, but if you were changing a liner to adjust for seasons, you would use zippers/buttons/snap fasteners.
      - See <https://en.wikipedia.org/wiki/Lining_(sewing)>
    - A better metaphor would be non-permanent joints, or just joints
      - > fasteners are used to create non-permanent joints; that is, joints that can be removed or dismantled without damaging the joining components
      - object/link/preprocessing joint
      - Arguably some of the dependency breaking techniques in this book are examples of replacing seams with joints! Like "Parameterize Constructor".
- Idea snippets
  - Maximizing `[[Test scope]]` is not necessarily a good idea, the larger the extent the poorer the localization
  - To understand consequences of a change create an effect sketch
  - To understand how things work now create a feature sketch or do a scratch refactoring
  - To preserve behavior write characterization tests
  - > tests that specify become tests that preserve
    - Note that this has a negative effect as well, if you have lots of tests that depend on the exact structure of the code, they will preserve the structure of the code even if it is beneficial to change that structure.
- Chapter 1: Changing Software
- Chapter 2: Working with Feedback
  - > Superficially, Edit and Pray seems like "working with care," a very professional thing to do. The "care" that you take is right there at the forefront, and you expend extra care when the changes are very invasive because much more can go wrong. But safety isn't solely a function of care. I don't think any of us would choose a surgeon who operated with a butter knife just because he worked with care. Effective software change, like effective surgery, really involves deeper skills. Working with care doesn't do much for you if you don't use the right tools and techniques.
  - > few problems with large tests:
    - error localization
    - execution time
    - coverage
      - > It is hard to see the connection between a piece of code and the values that exercise it.
      - > One of the most frustrating things about larger tests is that we can have error localization if we run our tests more often, but it is very hard to achieve. If we run our tests and they pass, and then we make a small change and they fail, we know precisely where the problem was triggered. It was something we did in that last small change. We can roll back the change and try again. But if our tests are large, execution time can be too long; our tendency will be to avoid running the tests often enough to really localize errors.
  - > Here are qualities of good unit tests:
    > 1. They run fast.
    > 2. They help us localize problems.
  - > The Legacy Code Dilemma: When we change code, we should have tests in place. To put tests in place, we often have to change code.
  - > When you break dependencies in legacy code, you often have to suspend your sense of aesthetics a bit. Some dependencies break cleanly; others end up looking less than ideal from a design point of view. They are like the incision points in surgery: There might be a scar left in your code after your work, but everything beneath it can get better.
    >
    > If later you can cover code around the point where you broke the dependencies, you can heal that scar, too.
  - The Legacy Code Change Algorithm
    - 1. Identify change points.
      - Chapter 16, `I Don't Understand the Code Well Enough to Change It`
      - Chapter 17, `My Application Has No Structure`.
    - 2. Find test points.
      - Chapter 11, `I Need to Make a Change. What Methods Should I Test?`
      - Chapter 12, `I Need to Make Many Changes in One Area. Do I Have to Break Dependencies for All the Classes Involved?`
    - 3. Break dependencies.
      - Chapter 23, `How Do I Know That I'm Not Breaking Anything?`
      - Chapter 9, `I Can't Get This Class into a Test Harness`
      - Chapter 10, `I Can't Run This Method in a Test Harness`
      - Chapter 22, `I Need to Change a Monster Method and I Can't Write Tests for It`
      - Chapter 7, `It Takes Forever to Make a Change`
    - 4. Write tests.
      - Chapter 13, `I Need to Make a Change but I Don't Know What Tests to Write`
    - 5. Make changes and refactor.
      - Chapter 8, `How Do I Add a Feature?`
      - Chapter 20, `This Class Is Too Big and I Don't Want It to Get Any Bigger`
      - Chapter 22, `I Need to Change a Monster Method and I Can't Write Tests for It`
      - Chapter 21, `I'm Changing the Same Code All Over the Place`
- Chapter 3: Sensing and Separation
  - > Generally, when we want to get tests in place, there are two reasons to break dependencies: sensing and separation.
    - > Sensing - We break dependencies to sense[,] when we can't access values our code computes.
    - > Separation - We break dependencies to separate[,] when we can't even get a piece of code into a test harness to run.
- Chapter 4: The Seam Model
  - > A **seam** is a place where you can alter behavior in your program without editing in that place.
  - > Every seam has an **enabling point**, a place where you can make the decision to use one behavior or another.
- Chapter 5: Tools
  - Covers testing and refactoring tools, not very relevant 20 years after the books publication
- Chapter 6: I Don't Have Much Time and I Have to Change It
  - Sprout Method
  - Sprout Class
  - Wrap Method
  - Wrap Class
  - The Decorator Pattern
  - > The biggest obstacle to improvement in large code bases is the existing code. "Duh," you might say. But I'm not talking about how hard it is to work in difficult code; I'm talking about what that code leads you to believe. If you spend most of your day wading through ugly code, it's very easy to believe that it will always be ugly and that any little thing that you do to make it better is simply not worth it.
- Chapter 7: It Takes Forever to Make a Change
  - Covers iteration cycles based on build times, basically "make it unnecessary to recompile by using interfaces"
- Chapter 8: How Do I Add a Feature?
  - TL;DR: use TDD
  - With some Liskov Substitution thrown in
  - > Whenever possible, avoid overriding concrete methods
  - >  In a normalized hierarchy, no class has more than one implementation of a method. In other words, none of the classes has a method that overrides a concrete method it inherited from a superclass.
- Chapter 9: I Can't Get This Class into a Test Harness
  - > Here are the four most common problems we encounter:
    > 1. Objects of the class can't be created easily.
    > 2. The test harness won't easily build with the class in it.
    > 3. The constructor we need to use has bad side effects.
    > 4. Significant work happens in the constructor, and we need to sense it.
    - Points 1,3,4 are echoed in `[[Testing Without Mocks: A Pattern Language]]` section Zero-Impact Instantiation
  - OOP galore
- Chapter 10: I Can't Run This Method in a Test Harness
  - > Command/Query Separation is a design principle first described by Bertrand Meyer. Simply put, it is this: A method should be a command or a query, but not both. A command is a method that can modify the state of the object but that doesn't return a value. A query is a method that returns a value but that does not modify the object.
    >
    > Why is this principle important? There are a number of reasons, but the most primary is communication. If a method is a query, we shouldn't have to look at its body to discover whether we can use it several times in a row without causing some side effect.
- Chapter 11: I Need to Make a Change. What Methods Should I Test?
  - > When I need to make changes in particularly tangled legacy code, I often spend time trying to figure out where I should write my tests. This involves thinking about the change I am going to make, seeing what it will affect, seeing what the affected things will affect, and so on.
  - > **effect sketch** - A small hand-drawn sketch that shows what variables and method return values can be affected by a software change. Effect sketches can be useful when you are trying to decide where to write tests.
  - > When we need to find out where to write our tests, it's important to know what can be affected by the changes we are making. We have to reason about effects. We can do this sort of reasoning informally or in a more rigorous way with little sketches, but it pays to practice it. In particularly tangled code, it is one of the only skills we can depend upon in the process of getting tests in place.
  - Curiously the chapter does not have a pithy answer to the question it poses.
  - Without using interception/pinch point terms, one summarization is "Test the endpoints where effects are visible"
- Chapter 12: I Need to Make Many Changes in One Area. Do I Have to Break Dependencies for All the Classes Involved?
  - > **interception point** - A place where a test can be written to sense some condition in a piece of software.
  - > **pinch point** - A narrowing in an effect sketch that indicates an ideal place to test a cluster of features.
  - >  finding a decent interception point can be a big deal [...] How do we start? The best way to start is to identify the places where you need to make changes and start tracing effects outward from those change points.
  - > When you find a pinch point, you've found a narrow funnel for all of the effects of a large piece of code.
    - Compare with Philosophy of Software Design by John Ousterhout, the deep vs shallow modules
  - > Sometimes when you have a large class, you can use effect sketches to discover how to break the class into pieces.
  - > Tests at pinch points are kind of like walking several steps into a forest and drawing a line, saying "I own all of this area." After you know that you own all of that area, you can develop it by refactoring and writing more tests. Over time, you can delete the tests at the pinch point and let the tests for each class support your development work.
- Chapter 13: I Need to Make a Change, but I Don't Know What Tests to Write
  - > Automated tests are a very important tool, but not for bug finding-not directly, at least. In general, automated tests should specify a goal that we'd like to fulfill or attempt to preserve behavior that is already there. In the natural flow of development, tests that specify become tests that preserve. You will find bugs, but usually not the first time that a test is run. You find bugs in later runs when you change behavior that you didn't expect to.
  - > **characterization test** - A test written to document the current behavior of a piece of software and preserve it as you change its code.
    - > There's no "Well, it should do this" or "I think it does that." The tests document the actual current behavior of the system.
  - > Here is a little algorithm for writing characterization tests:
    > 1. Use a piece of code in a test harness.
    > 2. Write an assertion that you know will fail.
    > 3. Let the failure tell you what the behavior is.
    > 4. Change the test so that it expects the behavior that the code produces.
    > 5. Repeat.
    - That's basically snapshot testing
  - > There is something fundamentally weird about doing this if you are used to thinking about these tests as, well, tests. If we are just putting the values that the software produces into the tests, are our tests really testing anything at all? What if the software has a bug? The expected values that we're putting in our tests could just simply be wrong.
- Chapter 14: Dependencies on Libraries Are Killing Me
  - > Avoid littering direct calls to library classes in your code. You might think that you'll never change them, but that can become a self-fulfilling prophecy.
  - Wow, that chapter is short
- Chapter 15: My Application Is All API Calls
  - TL;DR: "no it is not", split off things into layers and test what you can
  - > How do we choose between Skin and Wrap the API and Responsibility-Based Extraction?
    - > Skin and Wrap the API is good in these circumstances:
      > * The API is relatively small.
      > * You want to completely separate out dependencies on a third-party library.
      > * You don't have tests, and you can't write them because you can't test through the API.
    - > Responsibility-Based Extraction is good in these circumstances:
      > * The API is more complicated.
      > * You have a tool that provides a safe extract method support, or you feel confident that you can do the extractions safely by hand.
- Chapter 16: I Don't Understand the Code Well Enough to Change It
  - > Stepping into unfamiliar code, especially legacy code, can be scary. [...] You never know whether a change is going to be simple or a weeklong hair-pulling exercise that leaves you cursing the system, your situation, and nearly everything around you.
  - > When reading through code gets confusing, it pays to start drawing pictures and making notes.
  - > Check out the code from your version-control system. Forget about writing tests. Extract methods, move variables, refactor it whatever way you want to get a better understanding of it-just don't check it in again. Throw that code away. This is called **Scratch refactoring**.
- Chapter 17: My Application Has No Structure
  - > How can we get a big picture of a large system? There are many ways to do this. The book Object-Oriented Reengineering Patterns, by Serge Demeyer, Stephane Ducasse, and Oscar M. Nierstrasz (Morgan Kaufmann Publishers, 2002), contains a catalog of techniques that deal with just this issue.
  - Three techniques are discussed
    - Telling the Story of the System
    - Naked CRC (Class, Responsibility, and Collaborations)
    - Conversation Scrutiny
  - I didn't care much for them
- Chapter 18: My Test Code Is in the Way
  - Another short chapter on test naming and location of test files
- Chapter 19: My Project Is Not Object Oriented. How Do I Make Safe Changes?
  - link seam/preprocessor seam, function pointers, the usual
  - "It's All Object Oriented" is funny, every procedural program is really an object oriented program with one object
- Chapter 20: This Class Is Too Big and I Don't Want It to Get Any Bigger
  - Single Responsibility Principle, and how to "see responsibilities"
  - Heuristics for finding responsibilities
    - Heuristic #1: Group Methods
      - > Look for similar method names. Write down all of the methods on a class, along with their access types (public, private, and so on), and try to find ones that seem to go together.
    - Heuristic #2: Look at Hidden Methods
      - > Pay attention to private and protected methods. If a class has many of them, it often indicates that there is another class in the class dying to get out.
    - Heuristic #3: Look for Decisions That Can Change
      - > Look for decisions-not decisions that you are making in the code, but decisions that you've already made. Is there some way of doing something (talking to a database, talking to another set of objects, and so on) that seems hard-coded? Can you imagine it changing?
    - Heuristic #4: Look for Internal Relationships
      - > Look for relationships between instance variables and methods. Are certain instance variables used by some methods and not others?
      - > **feature sketch** - A small hand-drawn sketch that shows how methods in a class use other methods and instance variables. Feature sketches can be useful when you are trying to decide how to break apart a large class.
    - Heuristic #5: Look for the Primary Responsibility
      - > Try to describe the responsibility of the class in a single sentence.
      - > The Single Responsibility Principle tells us that classes should have a single responsibility. If that's the case, it should be easy to write it down in a single sentence.
    - Heuristic #6: When All Else Fails, Do Some Scratch Refactoring
      - > If you are having a lot of trouble seeing responsibilities in a class, do some scratch refactoring.
    - Heuristic #7: Focus on the Current Work
      - > Pay attention to what you have to do right now. If you are providing a different way of doing anything, you might have identified a responsibility that you should extract and then allow substitution for.
  - > The most subtle bugs that we can inject are bugs related to inheritance.
- Chapter 21: I'm Changing the Same Code All Over the Place
  - Removing duplication is good, mkay
- Chapter 22: I Need to Change a Monster Method and I Can't Write Tests for It
  - Some decent advice, there is lots of small details, nothing that can be easily quoted
- Chapter 23: How Do I Know That I'm Not Breaking Anything?
  - > I used to know many of the obscure parts of the C++ programming language, and, at one point, I had decent recall of the details of the UML metamodel before I realized that being a programmer and knowing that much about the details of UML was really pointless and somewhat sad.
  - > The language feature that gives us the most possibility for error when we lean on the compiler is inheritance.
  - > If you aren't pair programming right now, I suggest that you try it. In particular, I insist that you pair when you use the dependency-breaking techniques I've described in this book.
- Chapter 24: We Feel Overwhelmed. It Isn't Going to Get Any Better
  - > The key to thriving in legacy code is finding what motivates you.
  - > Sometimes people are dejected because their code base is so large that they and their team mates could work on it for 10 years but still not have made it more than 10 percent better. Isn't that a good reason to be dejected? Well, I've visited teams with millions of lines of legacy code who looked at each day as a challenge and as a chance to make things better and have fun. I've also seen teams with far better code bases who are dejected. The attitude we bring to the work is important.
- Chapter 25: Dependency-Breaking Techniques
  - Adapt Parameter - make method/function accept an interface instead of concrete type that is hard to instantiate under test. Languages with structural subtyping make this easy.
  - Break Out Method Object - wrap a method in a class, pass required data through the constructor. Useful for monster-classes with large number of instance variables.
  - Parameterize Constructor - pass things in, instead of constructing them in constructor.
  - > Naming is a key part of design. If you choose good names, you reinforce understanding in a system and make it easier to work with. If you choose poor names, you undermine understanding and make life hellish for the programmers who follow you.
  - > People create utility classes for many reasons. Most of the time, they are created when it is hard to find a common abstraction for a set of methods. The Math class in the Java JDK is an example of this. It has static methods for trigonometric functions (cos, sin, tan) and many others. When languages designers build their languages from objects "all the way down," they make sure that numeric primitives know how do these things. For instance, you should be able to call the method sin() on the object 1 or any other numeric object and get the right result.
    - This is a good example of taking OOP too far.
