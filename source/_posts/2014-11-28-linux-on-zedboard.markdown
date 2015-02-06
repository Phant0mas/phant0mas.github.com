---
layout: post
title: "Setup a Linaro GNU/Linux enviroment on the ZedBoard"
date: 2014-05-04 23:13:48 +0000
comments: true
categories: zedboard linux zynq
---

[Notice: This guide is outdated, but works. I will upload
a guide for newer sources sometime in the future!]

###Before we start

Disclaimers: I am sharing what works for me. It may not work for you or it may fail over time. You may suffer data loss or worse. I disclaim all warranties and representations. 
This guide is based on the one from digilent which you can find <a href="http://www.digilentinc.com/Data/Products/EMBEDDED-LINUX/ZedBoard_GSwEL_Guide.pdf">here</a>, and the one from Jan Gray 
which you can find <a href="http://fpgacpu.wordpress.com/2013/05/24/yet-another-guide-to-running-linaro-ubuntu-desktop-on-xilinx-zynq-on-the-zedboard/">here</a>.

For this guide I used an Arch GNU/Linux x86_64 box and the Xilinx ISE Design Suite, version 14.7 which you can get from 
<a href="http://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools.html">here</a>. 
This guide will probably work on any GNU/Linux box which can run the Xilinx tools, but I can't guarantee anything. If you 
are using another os, it will probably work with some modifications, but I can't guarantee that either.

In this post I will guide you through the process of getting a headless Linaro GNU/Linux system running on the ZedBoard. For those of you not familiar with the ZedBoard, which I highly doubt 
since you are here, <a href="http://www.zedboard.org/product/zedboard">read this</a>. 

###So, why run Linaro on Zedboard?

<p>Well, there are two main reasons for that:</p> 
<ol>
<li>Linaro comes with a working gnu toolchain so you can actually build and debug directly on it, without the need of your main workstation. </li>
<li>As it is based on Ubuntu, you can have access to the large collections of programs in its repos, making the customization of the system a lot easier.</li>
</ol> 

###What we're going to build

<ul>
<li>An XPS design for ZedBoard, which we’ll export to the SDK.</li>
<li>A u-boot.elf (Linux boot loader).</li>
<li>An FSBL (first stage boot loader) using the SDK.</li>
<li>The linux kernel.</li>
<li>A devicetree blob named devicetree.dtb.</li>
<li>A FAT32 partition on our SD card that comprises these files BOOT.BIN, uImage, and devicetree.dtb.</li>
<li>An ext4 partition on our SD card with the pre-built Linaro Ubuntu userland .</li>
</ul> 

###Prerequisities

<ul>
<li>Just make sure ISE 14.7 w/ EDK is there and working.</li>
</ul>

###Prepare the SD card

To boot the system on the ZedBoard you’ll need a SD memory card. The SD card should have at least 4 GB of storage and it is recommended to use a card with speed-grade 6 
or higher to achieve optimal file transfer performance. The SD card needs to be partitioned with two partitions. I suggest to make the first one be about 256MB in size and the second one 
should take up the remaining space. For optimal performance make sure that the partitions are 4MB aligned. The first partition needs to be formatted with a FAT filesystem. It will 
hold the bootloader, devicetree and kernel images. Name it ZED_BOOT. The second partition needs to be formatted with a ext4 filesystem. Name it ROOT_FS. It will store the systems root filesystem.
Use whatever tool you want to do it :-).

###Building the programmable logic hardware

<ul>
<li>Download the reference design for ZedBoard from <a href="http://www.digilentinc.com/Data/Products/ZEDBOARD/ZedBoard_Linux_Design.zip">here</a>.</li>
<li>Create a folder named tutorial.</li>
```
$ mkdir tutorial
```
<li>Change folder to tutorial.</li>
```
$ cd tutorial
```
<li>Unzip the file you download above, in here.</li>
```
$ unzip ../ZedBoard_Linux_Design.zip .
```
<li>Change folder to ZedBoard_Linux_Design.</li>
```
$ cd ZedBoard_Linux_Design
```
<li>Open system.xmp file in hw/xps_proj with xps.</li>
```
$ xps hw/xps_proj/system.xmp &
```
<li>Click yes when asked to upgrade cores to newer version.</li>
<li>Click <strong>Generate BitStream</strong> and <strike>start making fun of windows l-users</strike> <strike>play some ksp</strike> 
work-ahead on the u-boot and linux kernel steps below, while you check back on the progress on this step. When it's finished, check if there are no errors and 
pretend you don't see the warnings.</li>
<li>Click Export Design. Select Export and Launch SDK. (Continued below.)</li>
</ul> 

###Build u-boot, the Linux boot-loader

<ul>
<li>If you have properly installed the ISE suite in your box, you should already have the ARM cross compile toolchain installed, which will work just fine.</li>
<li>Fetch the source:</li>
```
$ git clone https://github.com/Digilent/u-boot-digilent.git ../u-boot-digilent ; cd ../u-boot-digilent
```
<li>Build u-boot with the cross-compile tools</li>
```
$ make  CROSS_COMPILE=arm-xilinx-linux-gnueabi- zynq_zed_config
Configuring for zynq_zed board...
```
```
$ make  CROSS_COMPILE=arm-xilinx-linux-gnueabi-
```
<li> After the compilation, the ELF (Executable and Linkable File) generated is named u-boot. We
need to add the <strong>'.elf'</strong> extension to the file name so that Xilinx SDK can read the file layout and
generate BOOT.BIN. In this tutorial, we are going to move the u-boot.elf to boot_image
folder and substitute the <strong>u-boot.elf</strong> that comes along with ZedBoard Embedded Linux Design
Package.</li>
```
$cp u-boot ../ZedBoard_Linux_Design/boot_image/u-boot.elf 
```
</ul> 

###Generate the boot image BOOT.BIN

<ul>
<li>This consists of the FSBL (first stage boot loader), the system.bit configuration bitstream, and the U-boot Linux boot-loader u-boot.elf. Follow exactly the instructions.</li>
<li>By now xps should have finished generating the bitstream. So at xps, export the hardware design to Xilinx SDK by clicking on <strong>Project -> Export Hardware Design to SDK</strong></li>
<li>Click <strong>Export & Launch SDK</strong></li>
<li>Set Workspace to <strong>ZedBoard_Linux_Design/hw/xps_proj/SDK/SDK_Export</strong> and click ok</li>
<li>After SDK launches, the hardware platform project is already present in Project Explorer on the
left of the SDK main window. We now need to create a First Stage
Bootloader (FSBL). <strong>Click File->New->Project</strong></li>
<li> In the New Project window, select <strong>Xilinx->Application Project</strong>, and then Click Next.</li>
<li> We will name the project <strong>FSBL</strong>. Select <strong>xps_proj_hw_platform for Target Hardware</strong> because it
is the hardware project we just exported. Select <strong>standalone</strong> for OS Platform. Click Next.</li>
<li>Select <strong>Zynq FSBL</strong> as template, and click Finish</li>
<li>For the ZedBoard, we need to reset the USB PHY chip by toggling the USB-Reset pin in the FSBL. 
Add the following code to main.c of the FSBL project after the line 565</li>
```
        /* Reset the USB */

        fsbl_printf(DEBUG_GENERAL, "Reset USB...\r\n");

        /* Set data dir */
        *(unsigned int *)0xe000a284 = 0x00000001;

        /* Set OEN */
        *(unsigned int *)0xe000a288 = 0x00000001;
        Xil_DCacheFlush();

        /* For REVB Set data value low for reset, then back high */
#ifdef ZED_REV_A
        *(unsigned int *)0xe000a048 = 0x00000001;
        Xil_DCacheFlush();
        *(unsigned int *)0xe000a048 = 0x00000000;
        Xil_DCacheFlush();
#else
        *(unsigned int *)0xe000a048 = 0x00000000;
        Xil_DCacheFlush();
        *(unsigned int *)0xe000a048 = 0x00000001;
        Xil_DCacheFlush();
#endif
```
<li>After you have saved the changes to main.c, the project will rebuild itself automatically. If it does
not rebuild, Click <strong>Project->Clean</strong> to clean the project files, and <strong>Project->Build All</strong> to rebuild all
the projects. The compiled ELF file is located in
<strong>ZedBoard_Linux_Design/hw/xps_proj/SDK/SDK_Export/FSBL/Debug/FSBL.elf</strong></li>
<li>Now, we have all the files ready to create BOOT.BIN. Click Xilinx Tools -> Create Zynq Boot Image.</li>
<li>In the Create Zynq Boot Image window, choose <strong>Create new Biff file</strong> and click <strong>Browse</strong>. Go to <strong>tutorial-zedboard/ZedBoard_Linux_Design/boot_image/</strong> path and 
type BOOT.bif as the filename you want. It does not yet exist but it will get created.</li>
<li>Next in the <strong>Boot image partitions</strong> area click add, choose <strong>Partition type -> bootloader</strong>, add 
the <strong>FSBL.elf</strong> found at <strong>ZedBoard_Linux_Design/hw/xps_proj/SDK/SDK_Export/FSBL/Debug/</strong> 
to the file path and click ok.</li>
<li>Click add again, <strong>Partition type -> datafile</strong>, add to the file path the <strong>system.bit</strong> found at 
<strong>ZedBoard_Linux_Design/hw/xps_proj/SDK/SDK_Export/xps_proj_hw_platform/</strong> and click ok.</li>
<li>Repeat the above, but this time add <strong>u-boot.elf</strong> found at <strong>ZedBoard_Linux_Design/boot_image/</strong>.</li>
<li>Finally click <strong>Create Image</strong> and a file named <strong>output.bin</strong> is generated in the <strong>ZedBoard_Linux_Design/boot_image</strong> folder.</li>
<li>Change the name of <strong>output.bin</strong> to <strong>BOOT.BIN</strong> and you are done.</li>
```
$ cd ZedBoard_Linux_Design/boot_image
$ mv output.bin BOOT.BIN
```
</ul> 

###Build the Linux Kernel

<ul>
<li>Get the Linux kernel source code from Digilent git repository. Make sure you are in the tutorial root folder.</li>
```
$ pwd
/home/something/tutorial
$ git clone https://github.com/Digilent/linux-digilent.git linux-digilent ; cd linux-digilent
```
<li>We will start to configure the kernel with the default configuration for ZedBoard. The
configuration is located at arch/arm/configs/digilent_zed_defconfig. To use the default 
configuration, you can use:</li>
```
$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- digilent_zed_defconfig
```
<li>We will keep the default kernel configuration, so use the command bellow and then just press exit.</li>
```
$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- menuconfig
```
<li>Build the Kernel</li>
```
$ make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
```
<li>After the compilation, the kernel image is located at arch/arm/boot/zImage. Copy it to the boot_image folder.</li>
```
$ cp arch/arm/boot/zImage ../ZedBoard_Linux_Design/boot_image/
```
</ul>
 
###Build the device tree

<ul>
<li>Note your DTS file arch/arm/boot/dts/digilent-zed.dts if it includes these bootargs:</li>
```
bootargs = "console=ttyPS0,115200 root=/dev/mmcblk0p2 rw earlyprintk rootfstype=ext4 rootwait devtmpfs.mount=1";
/* bootargs = "console=ttyPS0,115200 root=/dev/ram rw initrd=0x800000,8M init=/init earlyprintk rootwait devtmpfs.mount=1"; */
```
<li>That’s good — Linux will mount your root file system from the second partition on your SD card.</li>
<li> Generate DTB file.</li>
```
$ ./scripts/dtc/dtc -I dts -O dtb -o ../ZedBoard_Linux_Design/boot_image/devicetree.dtb arch/arm/boot/dts/digilent-zed.dts 
DTC: dts->dtb  on file "arch/arm/boot/dts/digilent-zed.dts"
```
</ul>

###Start copying to sd card

<ul>
<li>Copy to the <strong>ZED_BOOT</strong> partition of the sd card, that has the FAT filesystem, the files <strong>BOOT.BIN, devicetree.dtb, zImage</strong> that we created before, found in the 
<strong>ZedBoard_Linux_Design/boot_image</strong> folder.</li>
<li>Now it's time to download the Linaro image, which you can find <a href="http://releases.linaro.org/14.04/ubuntu/saucy-images/developer/linaro-saucy-developer-20140410-652.tar.gz">here</a>.</li>
<li>Create a folder under /tmp named linaro, and copy the zipped Linaro image to it.</li>
```
$ mkdir -p /tmp/linaro
$ sudo cp linaro-saucy-developer-20140410-652.tar.gz /tmp/linaro/fs.tar.gz
$ cd /tmp/linaro/
```
<li> Unpack the disk image using the tar command.</li>
```
$ sudo tar -xvf fs.tar.gz
$ ls
binary	 fs.tar.gz

```
<li>Unmount any automatically mounted partitions of the sd card.</li>
<li>Mount the SD Card to /tmp/sd_ext4. Make sure to replace the device node with the device node of the ext4 partition on your SD Card.</li>
```
$ mkdir -p /tmp/sd_ext4
$ sudo mount /dev/sdX2 /tmp/sd_ext4
```
<li>Use the command rsync to copy the root file system onto the SD card. This command will
preserve those attributes that should remain unchanged.</li>
```
$ cd binary/
$ pwd
/tmp/linaro/binary
$ sudo rsync –a ./ /tmp/sd_ext4
```
<li>Unmount before removing the SD card to make sure all the files have been synchronized to it.
Unmounting /tmp/sd_ext4 may take several minutes, but you must wait to see that umount
returns before removing the SD card.</li>
```
$ umount /tmp/sd_ext4
```
<li>Everything is ready!!</li>
</ul>

###Booting the SD Card

Once you complete these guide instructions, the SD card will have everything it needs to boot Linux
on the ZedBoard. Complete the procedures in steps 1-7 to test your SD card with the ZedBoard.

<ol>
<li> Insert the SD card into the ZedBoard.</li>
<li> Set the jumpers on the ZedBoard as follows:</li>
     <ul>
     <li>MIO 6: set to GND</li>
     <li>MIO 5: set to 3V3</li>
     <li>MIO 4: set to 3V3</li>
     <li>MIO 3: set to GND</li>
     <li>MIO 2: set to GND</li>
     <li>VADJ Select: Set to 1V8</li>
     <li>JP6: Shorted</li>
     <li>JP2: Shorted</li>
     <li>All other jumpers should be left unshorted</li>
     </ul>
<li>Attach a computer running a terminal emulator to the UART port with a Micro-USB cable.
Configure the terminal emulator with the following settings:</li>
     <ul>
     <li>Baud: 115200</li>
     <li>8 data bits</li>
     <li>1 stop bit</li>
     <li>no parity</li>
     </ul>
<li>Attach a 12V power supply to the ZedBoard and power it on.</li>
<li> Connect to the appropriate port in the terminal emulator. You should begin to see feedback
from the boot process within a few seconds, depending on the speed of the SD card.</li>
<li>Wait for the boot process to complete. If it gets stuck at the u-boot prompt just type reset and it will work.</li>
<li>You now have a complete GNU/Linux system running on the ZedBoard.</li>
</ol>

