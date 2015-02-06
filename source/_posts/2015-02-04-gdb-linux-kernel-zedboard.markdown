---
layout: post
title: "Debug a running linux kernel on the zedboard"
date: 2015-02-05 17:21:16 +0000
comments: true
categories: linux kernel gdb zedboard
published: true
---

#####Disclaimers

I am sharing what works for me. It may not work for you or it may fail over time.
You may suffer data loss or worse. I disclaim all warranties and representations.

####Prerequisities

*   Xilinx Microprocessor Debugger (XMD)
*   GDB capable of understanding the target machine

###Debugging the Kernel

When developing a device driver, having access to the linux internals using GDB
may be the key to meeting that deadline. On the zedboard, debugging the kernel
with GDB is actually very easy with the help of the Xilinx Microprocessor Debugger,
or XMD for short.

XMD is included with the Vivado Design Suite from Xilinx. In case you are working
with the older ISE Design Suite, the included XMD should work as well.

###Start debugging

* Connect the JTAG to the zedboard (or a micro usb to the PROG USB port) and boot
   it.
* Open a shell and run ``xmd``.

{% codeblock lang:sh shell %}
user@workstation ~ $: xmd
Xilinx Microprocessor Debugger (XMD) Engine
Xilinx EDK 14.7 Build EDK_P.20131013
Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.

XMD% 
XMD% 

{% endcodeblock %}

* Run ``connect arm hw``. This will start GDB server at ``localhost:1234``.
{% codeblock lang:sh shell %}
XMD% connect arm hw

JTAG chain configuration
--------------------------------------------------
Device   ID Code        IR Length    Part Name
 1       4ba00477           4        Cortex-A9
 2       23727093           6        XC7Z020

--------------------------------------------------
Enabling extended memory access checks for Zynq.
Writes to reserved memory are not permitted and reads return 0.
To disable this feature, run "debugconfig -memory_access_check disable".

--------------------------------------------------

CortexA9 Processor Configuration
-------------------------------------
Version.............................0x00000003
User ID.............................0x00000000
No of PC Breakpoints................6
No of Addr/Data Watchpoints.........4

Connected to "arm" target. id = 64
Starting GDB server for "arm" target (id = 64) at TCP port no 1234
XMD% 
{% endcodeblock %}

* Open a new shell and go to the folder where the kernel sources are located, the
   ones you used to build the kernel, and run ``arm-xilinx-eabi-gdb vmlinux``.

   In my case I am using ``arm-xilinx-eabi-gdb`` but any arm targeted gdb will do.
   We are using ``vmlinux`` so the debugger can read the kernel symbols.

{% codeblock lang:sh shell %}
user@workstation ~/git_repos/linux-analog $: arm-xilinx-eabi-gdb vmlinux
GNU gdb (Sourcery CodeBench Lite 2013.11-46) 7.6.50.20130726-cvs
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
...
Reading symbols from /home/manolis/git_repos/linux-analog/vmlinux...done.
(gdb) 

{% endcodeblock %}

* Then,under the GDB command prompt, enter: ``target remote localhost:1234``

{% codeblock lang:sh shell %}
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
cpu_v7_do_idle () at arch/arm/mm/proc-v7.S:74
74		ret	lr
(gdb) 
{% endcodeblock %}

* And now GDB is ready for debugging those kernel hangs. Enter ``continue``
in the gdb prompt so linux can continue it's normal operation. You can come back
anytime and stop it in order to debug it. 

####Extras
* Make sure you have enabled the kernel debug symbols in the config file of the
  kernel. Enabling ``CONFIG_DEBUG_INFO`` will do the trick. 