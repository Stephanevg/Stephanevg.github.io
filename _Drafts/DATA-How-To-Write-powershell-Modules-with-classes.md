---
layout: post
title: How to write Powershell modules with classes
---

working with Powershell Classes can be a bit tricky. There are multiple other edge cases that module / framework developers need to take into consideration when they want to add classes to their module / framework.

In this article I will demonstrate what are the ways to organize code for a PowerShell modules that contains classes, functions and enums. I will demonstrate the advantages and drawbacks of each solution, and present how I standardly build my modules through writing modules for the last 5 years. I have found the perrfect solution (in my opinion), which works for every case, and today I will be sharing this with you.

# Introduction

I have been working with Powershell classes since Powershell 5.0 got in february 2016.
I have set my self a rule of thumb, to force my self into learning this: To `Write only classes.` And this is what I have done ever since.
At work, or in my personal open source projects like [PSHTML](https://github.com/Stephanevg/PSHTML) or [PSClassUtils](https://github.com/Stephanevg/PsClassUtils) for instance, I have applied that rule. And I am really happy I did.
Here is why. 

# How to write a powershell module with classes?

To understand what is the best way to write a powershell module that uses classes, I think it make sense to have a look at what is annoying and what works well for end users that are actually using a module that has been written with classes.

The user experience is directly influenced on how one loads a class. We have to ways to do so:
1) `import-Module`
2) `Using Module`

I will go through each of these paths, and we will look together at what each of these methods can and cannot do.

I'll cover firstly the `Using Module` statement, and then takle the `import-Module` one. I'll conclude with short summary about the differences / identicalities.

## Using Module vs Import-Module

For the benefit of making this the most clear as possible, Let's assume we have a module file called `plop.psm1` that contains the following code:

```powershell

Enum ComputerType {
    Server
    Client
}

Class Computer {
    [String]$Name
    [ComputerType]$Type
}

Function Get-InternalStuff {
    #Does internal stuff 
}

Function Get-ComputerData {
    #Does stuff
}

Export-ModuleMember -Function Get-ComputerData 

```

It contains an Enum, a Class, and two functions, but **only**  `Get-ComputerData` is exported.

> For this example, a module manifest is not necessary.

## The `using module` statement

The `using module` statement got added in Powershell version 5 (February 2016). It will load any class, Enum and exported function into the current session.

We can use the `using module` statement to load our module into our session like this :

```powershell
Using module plop
```

> The using statement **must** be located at the very top of your script. It also **must** be the very first statement of your script (Except of comments). This make loading the module 'conditionally' for example impossible.

![using module statement](../images/using-modulestatementError.jpg)

_Trying to load a module using `using module` in a script after a `Get-Service` call_

Once loaded using the `using module` statement, let's have a look at what commands have actually been loaded into our session by calling the `Get-Command -Module` cmdlet.

```powershell
Get-command -Module plop

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ComputerData                                     0.0        plop

```

we see that only `Get-ComputerData` is available. If we try to use `Get-InternalStuff` It throws an error. 

```powershell
get-internalStuff

get-internalStuff : The term 'get-internalStuff' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if 
a path was included, verify that the path is correct and try again.
At line:1 char:1
+ get-internalStuff
+ ~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (get-internalStuff:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

```

>This error is a normal behaviour since the only command we exported from the module was `Get-ComputerData`.

There is **no** 'out of the box' and **simple** way to list the available classes. This can only be done with the usage of the AST, which ends up to be quite combersome. The easier and better option to list the available classes is to use `Get-CUClass` which is present in [PsClassUtils](https://github.com/Stephanevg/PSClassUtils)

> There is a module Called [PsClassUtils](https://github.com/Stephanevg/PSClassUtils) which allows to list the current available classes in a session, including their constructors, methods and properties. It can also generate pester tests automatically for your classes, and draw awesome UML diagrams. I would **highly** recommend you have a look at this module if you intend to use classes. You can download **PsclassUtils** using `Install-Module PsClassUtils`.
You can find the Github project  [here](https://github.com/Stephanevg/PSClassUtils)

The class `Computer` __is__ present, and we can instanciate as follow:

```powershell
[Computer]::New()

Name   Type
----   ----
     Server
```

The Enum is also available to be used:

```powershell
[ComputerType]::Client
Client
```

So everything works as expected.

### Import-module

`Import-module` is the command that allows to load the contents of a module into the session. It has been available since Powershell version 2 (October 2009) and has been the **only** way of loading a module up until powershell version 5 (February 2016).

`import-Module` must be called before the function you want to call. But **__necessarly__** at the begining / top of your script. (And this is an important point which I will come back to in just a little a bit.)

Looking at the functions that are available to us using `get-Command`

```powershell
Get-command -Module plop

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ComputerData                                           0.0        plop

```

we see that only `Get-ComputerData` is available. If we try to use `Get-InternalStuff` It throws an error. 

```powershell
get-internalStuff

get-internalStuff : The term 'get-internalStuff' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if 
a path was included, verify that the path is correct and try again.
At line:1 char:1
+ get-internalStuff
+ ~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (get-internalStuff:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

```

When trying to instanciate the class, it will throw an error saying it didn't found the Type. Which really means that it couldn't find the class.

```powershell
 [Computer]::New()
Unable to find type [Computer].
At line:1 char:1
+ [Computer]::New()
+ ~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (Computer:TypeName) [], RuntimeException
    + FullyQualifiedErrorId : TypeNotFound
```

Using the `import-module` command, we have access to the same exported classes as the `using module` statement, but we don't have access to the classes. It can be called anywhere in a script, and doesn't need to be the first statement of the script.

## summary

The following table summarized the difference in loading between `using module` and  ```import-module```.

Command Type | Can be anywere in script | internal functions | public functions | Enums | Classes
--- | --- | --- | --- | --- | ---
Import-Module | Yes | No | Yes | No | No 
using Module | No | No | Yes | Yes | Yes 

So, in both ways we don't have the same features covered.

Another point I didn't mention, is that to actually use class, we need to instanciate it. This done by calling the class like this ```[Computer]::New()```.
For some people that have grown with 'Import-module` and / or that have the need to add some conditionals it might add another layer of complexity.
A class does **not** has any comment based help. On the other hand, people that want to keep using `import-module` are limited to only using functinos, since classes and Enums do **not"" loaded into host using the right commnad.


# So how to get the best of the both worlds?