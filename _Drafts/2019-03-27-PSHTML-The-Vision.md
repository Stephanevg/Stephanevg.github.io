---
layout: post
title: PSHTML - The vision
---

In this post I would like to talk a bit PSHTML. Not technically, but on a product level, where we stand today (features currently developed) and where I would like to bring it.

> This is really just a vision. It might change a bit with the experience through time (and I might even update this post the) an the order might be different. But for now, theese are the steps I would really like to accomplish in the next months.

# A look back over the shoulder

> Before even starting here, I would like to SUPER THANK all the contributors to this projects. Some of them fixed some typos, others wrote complete cmdlets, and others corrected a bug, or added a parameter to a specific cmdlet. In ALL cases, I want to say a big, no, a HUGE thank you. see people getting involved in this project makes me so happy and proud. The project would not be half as good as it is today without your contribution guys. &hearts&

When we have a close look at what PSHTML has grown to come, I have to say I am quite happy (proud?) of the current state of the project.

I have been able to implement most of the features I wanted thought of having:
- [X] Cover the most common HTML tags
-- If you see one that is missing, please [Let me know!](https://github.com/Stephanevg/PSHTML/issues/new) 
- [ ] Includes (Templating)
- [ ] Addind Charting functionality
- [ ] Adding Assets (Native BootStrap, JQuery & CharJS)
- [ ] Logging functionality
- [ ] Configuration functionality

On top of that, the project has had two major refactorings __(which have been transparent for you, the end users)__ but which made the developement of this module, and the additionals of new features so much better.

There is major refacotorings I am still willing to do:

### Refactor how HTML tags are generated

Currently (in version 0.7.3) All the html tags are generated using a private function, and all the logic is contained in that function. In version `7.0`I have introduced a dependency on `Powershell version 5.1 (or higher)` with the introduction of the Charting functionality, which is almost 100% build of classes. Although there is nothing wrong with the current implementation, I think that refactoring the way we generate the HTML tags with classes  will make any further additions easier, as we would have the possibility to use OOP methodologies like inheritance and Polymorphism. 


But PSHTML is still a young module, and it has so much groth potential, that I get really excited about it each time I think of it.


# The bigger picture

`PSHTML` in it own is great to generate static webpages. And it does it pretty well. The second logical step would be to enable dynmaic rendering scenarios. As PSHTML generates HTML content on the fly and simply returns it to whoever asks for it,  this second step can be done pretty easily using one of multiple technologies.

Some of the technologies that would support this would be the following ones:
- Polaris
- Nodejs

And these two are the ones I would like to support, eventually.

`PSHTML` is really a front end language rendering module. It is good at that. And doesn't know aynthing about the backed end stuff. For that, other modules / products exists, which do their part of the job really well as well. It is called the seperation of concerns, and that is a good thing!

This means that PSHTML has accomplished almost all of his potential growth, and will not integrate the back end part. Never. Ever.

**But**  this doesn't mean that `PSHTML` will never be part of a solution that contains backend + rendering engine... And that will exactly be our next step ;)

## The next step

As you understand the current state of PSHTML, and the growth possiblities, I want to takle that last part soon. I have already created small POC's locally and have discussed this with well know MVP's or even people from Microsoft. The idea is jung, but everybody seems to agree, that the best solution is to go for a meta module.

> What is a meta module you might ask? A meta module is module that would be composed of several other modules. It existence is very thin, as it's main real purpose would be to bring to seperates modules together in one place. This is a great way to avoid to add a strong dependency on PSHTML on a module like Polaris, or a tool like Nodejs for instance.

In next couple of months, I would like to create this meta module, which would be the glue between these different modules. It will certainly have some flavoring, to make management a bit easier. (Perhaps even Adding support for web design patterns such as MVC etc.. Why not!). 
Ideally I would like to support as much as rendering engines Like `PSHTML` and `Markdown` for instance, and also back end servers like `Polaris` `NodeJs` etc..
Perhaps each of this combination will end up beeing a meta module in it self, or perhaps they will come as options / plugins in this first Meta module. That hasn't been decided yet, will have to be evaluated. 

To recude the scope of this whilst keeping the big picture in the back of my brain, I will like to focus on implementing the first combination that seems the most logical to me: `Polaris` + `PSHTML`

> For the ones that don't know Polaris yet, Polaris is A cross-platform, minimalist web framework for PowerShell. 
Polaris could be a webserver or an API routes server. And you can create this in seconds from the command line. 100% in Powershell.
You can get more information on the project here -> [Polaris](https://github.com/PowerShell/Polaris)

Simply because `PSHTML` is written in `Powershell` and I know it inside out. `Polaris` because it is written in `PowerShell` as well, and I could find my way trough it. Also, I have already done some POC with these two technologies together, so did some other PowerShell MVP's in this combination. We already know it works well together (like soda + ice cubes during a very warm day in august) and we are confident that this is where we will be able to have a working solution the fastest.

