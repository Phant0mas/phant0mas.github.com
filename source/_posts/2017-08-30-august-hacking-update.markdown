---
layout: post
title: "My August Hacking Update"
date: 2017-08-30 14:00:25 +0300
comments: true
categories: 
---
## August out!

August is almost over. The same could be said for the summer, but I am in Greece.
I will probably still be using A/C at least until November :P. The first
half of the month was really productive, but then I removed two of my wisdom teeth
and I had to take it easy. Anyhow let's see what I got done.

## My work on Guix

``` bash Guix master 
$ git log --since="last month" --author=Manolis  --pretty='format:%h %cd %s' --date=format:'%Y-%m-%d' --reverse
9ef5940ce 2017-08-02 gnu: calibre: Add python2-msgpack as an input.
5638d7150 2017-08-03 gnu: openscenegraph: Add 'Release' configure flag.
c608fe8cf 2017-08-09 gnu: Add ois.
2d5bf32b8 2017-08-09 gnu: googletest: Build shared libraries.
dd75a9a22 2017-08-17 gnu: Add ogre.
42d0d13de 2017-08-17 gnu: Add mygui.
e9a599cdc 2017-08-17 gnu: Add OpenMW.

```

While I thought packaging OpenMW would take me longer, I managed to track the dependencies,
package them, and make the tests work with some serious two week work. 

{% img images/openmw-screenshot.png  'OpenMW on GuixSD' %}

Let's say now that you are thinking about contributing to OpenMW, and you are also using
Guix (or GuixSD). Here is how you can setup your environment, fast:

``` bash OpenMW Environment
manolis@prometheus ~/repos/openmw $ guix environment openmw  --pure
substitute: updating list of substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
substitute: updating list of substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
manolis@prometheus ~/repos/openmw [env]$
```

And just like that you have an environment with all the openmw dependencies and 
you are ready to start hacking. 

## Smart Home Project

The home project is moving forward. The windows will probably arrive next week 
(they are currently being painted.) and today I connected the new cat6 
underground lines to the phone company's (OTE) cables. It was a miracle how the
old cables were still working, as they were in a miserable condition.
I think the result speaks for itself.

{% img images/2017-08-31_12.01.11.jpg  'Phone cables 1' %}

{% img images/2017-08-31_12.02.04.jpg 'Phone cables 2' %}

I also started working on the hardware for the smart locks. I experimented a 
bit on my room's door and this is the prototype. 

{% img images/2017-08-30_20.43.06.jpg  'Electric Door' %}

I am using an Arduino and a mosfet to drive the 12V electric lock. I am also
planing to install a cover with a keypad on the outside of the door. Mainly 
as a way to open the door in case I forget my phone and to cover the missing
parts of the door :P.

## Reading Books

There are some books that every CS student should read in order to call himself
one. One of those is "Structure and Interpretation of Computer Programs" or SICP
for short. This book has enough material to teach you more than most students 
learn in Greek universities in 4 years time. And I finally got my hands on a 
hard copy!!

## September is coming

In the first 10 days of September I expect to install the new windows/doors in 
the house so I can finally get the new home network online. I will then be able
to start activating the smart home mechanisms and show everyone what I have in mind.
I also definitely hope that September will finally be the month I get to finish
my thesis text and defend it. We will see how it will go.

Manolis out.



