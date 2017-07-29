---
layout: post
title: "My hacking adventures."
date: 2017-07-29 12:20:08 +0300
comments: true
categories: hacking opinion report plan
---

## Long time no see

It's been a long time since I last updated this blog. Between my
studies, the last two GSoCs I was a part of and my personal life I had
little time to spend on this blog. Now this will change. With this post
I will tell you a little about some of the things I am working on and 
some goals I have in mind.

I hope that by the end of this post my mind will be better organized and get more productive!

## My work on Guix and Hurd

Two years ago I announced that [I successfully ported GNU Guix to GNU Hurd](https://lists.gnu.org/archive/html/guix-devel/2015-08/msg00379.html). 
But that didn't mean that everything was done. During GSoC 2016 I started 
working on creating a Hurd based GuixSD system. Unfortunately the time 
frame was not enough and 
[it needed more work](https://lists.gnu.org/archive/html/guix-devel/2016-08/msg01002.html).
But I have continued working on it and hopefully 
I will be able to deliver a working image soon. I also have help from a fellow hacker
called Rene, and which I am really thankful.

I try to push all of my work
to the upstream Guix repo, but sometimes my code doesn't meet the standards. 
As a result the day to day hacking happens in [a github repo](https://github.com/Phant0mas/Guix-on-Hurd).

I will write another post on how to use that repo to actually try Guix on Hurd yourself.

#### Things that work:
  * Guix can cross-build or build natively most of the packages needed
  for a GNU system and others.

#### Things I need to finish:
  * There is a library I wrote for the Hurd called [libhurdutil](https://github.com/Phant0mas/Hurd/commit/3501ee22ad4150b3b2cf9a386d2350b9a68aecd8) which I need
  to clean and finally push to Hurd.
  * Use the library above to finish implementing build isolation 
  in the Guix daemon while on Hurd.
  * Fix the packages that cannot be build but are needed for a GNU system.

## My work on Guix (but not Hurd :P)

I am using Guix in my everyday life a lot! This mean I had to add a couple of 
packages, not related to Hurd, in the span of these last 4 years . 

####Currently I need to finish:

  * The GNU Radio package.
  * The Open MW package. (I have already packaged its dependencies)

## My thesis on L4/Fiasco

The purpose of this thesis is to offer isolation between processes, 
where a process can be a simple app that read from a sensor to a fully fledged Linux system.
And all this on top of a zynq board, called zedboard, which is an FPGA + arm CPU. 
The plan is to control which process access what hardware. While running on the same system. 
And did I mention Fiasco is a microkernel? It sounded cool to me!

While the thesis did have some setbacks, which I will talk in another post, 
it has advanced enough to think that I will be able to defend it sometime 
in September. 

####Currently I need to:
  * Solve issues with accessing time controllers from inside the processes.
  * Write the thesis text.

In a future post I will get into the inner working of my thesis. Until 
then if you are not aware of L4/Fiasco please visit [here](https://os.inf.tu-dresden.de/fiasco/).

## My smart home project

A year go I was given the opportunity to finish the unfinished building which is directly 
upstairs from the one I am now. Suddenly the idea came. Why not automate as much as I can!?
Create a house which will learn its occupants. Design everything from scratch. And I started.

For the sake of not making the post longer than it is now, I will redirect you to my twitter
feed and [my conversations with David Thompson](https://twitter.com/phant0mas_/status/793166019976192000). 
In the near future I will add a post which I will get into the details of the house.


## This blog

David has created a static site generator called [haunt](https://haunt.dthompson.us/) in scheme.
Eventually I want to move this blog to haunt.

## Grand Plan?

Is this my Grand Plan? Well I am mostly seeing this as a way to bring my thoughts in
order and create a plan for the next six months. It doesn't necessarily mean that I 
will manage to finish everything but it's a good way to understand what I want to do,
by actually trying to explain everything in my head and in my notes to other people. 

By the end of this 6 months period, I will do my best to complete these goals!

Manolis out.
