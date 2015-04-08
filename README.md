# Buildroot Boards
This is a collection of build root boards that we have configured for our own project as a reference and for others to get started quickly with Buildroot.

To be more specific: This repository is working with the AT91 Buildroot fork as we currently mainly use AT91 based Atmel MCUs like SAMA5D3.

Currently these boards are supported:

* acqua (Acqua A5 from acmesystems.it)

## Important Info
Building the AT91 Bootstrap (boot.bin) file is currently broken. See Issue #2 for details. Until we have fixed that please follow Acmesystems tutorial "Compiling AT91Bootstrap 3.7" that you can find here: http://www.acmesystems.it/compile_at91bootstrap. Follow the instructions below, but instead of the Buildroot boot.bin copy the boot.bin from the tutorial on your SD and everything should be working fine.

If you are new to Qt5 you will run into a few issues. Issue #1 (https://github.com/appfruits/buildroot-boards/issues/1) and #2 (https://github.com/appfruits/buildroot-boards/issues/2) will have a lot of solutions that should get you up and running. I will soon write a blog post with a complete tutorial but until then follow the instructions below and then read issue #1 and issue #2 that should get you up and running in a minute.

## Install

In a linux terminal shell navigate to a folder where you want buildroot installed, i.e.
> cd ~
> mkdir Buildroot
> cd Buildroot

Now clone the standard buildroot repository
> git clone git://git.buildroot.net/buildroot
This will create a folder "buildroot" in your newly created Buildroot main folder

Now clone this repository
> git clone git://github.com/appfruits/buildroot-boards
This will create a folder named "buildroot-boards" as a sibling to the buildroot folder just created with the last git-call.

Your Buildroot folder should now look like this:

* Buildroot
  * buildroot
  * buildroot-boards

Navigate to the buildroot folder
> cd buildroot

Choose which board to configure, in this example we generate an image for Acqua A5 from acmesystems.it (acqua) and prepare the basic buildroot configuration for this board
> make BR2_EXTERNAL=../buildroot-boards acqua_defconfig

This call creates a local .config file that holds the current Buildroot state and fills it with the default config that has been setup by us and is based on the basic Acqua A5 configuration provided by acmesystems.it.

## Configure

We have configured Acqua A5 buildroot to generate these images:
* Device Tree with 7 inch LCD support
* Linux Kernel 3.10 (based on AT91 linux kernel fork)
* AT91 Bootloader (based on Acmesystems fork)
* Root file system with these libraries
  * Qt5 (everything that is available except QtWebKit)
  * Mesa (neccessary that Qt5 compiles the QtQuick1 module, which has the OpenGL dependency but runs without OpenGL)
  * i2c_tools
  * wpa_suplicant and other wireless tools (like iw)
  * nano text editor
  * Various libraries needed by Qt5 (libsvg, ...)
  * tslib
  * gstreamer1

If you have another or no LCD hooked up, you will need to change the DTS file used during the build process, this can be done with:
> make menuconfig

Navigate to Kernel -> Device tree source -> Press return and enter one of the following options:
* $(BR2_EXTERNAL)/board/acmesystems/acqua/acme-acqua_lcd_70.dts
* $(BR2_EXTERNAL)/board/acmesystems/acqua/acme-acqua_lcd_50.dts
* $(BR2_EXTERNAL)/board/acmesystems/acqua/acme-acqua_lcd_43.dts
* $(BR2_EXTERNAL)/board/acmesystems/acqua/acme-acqua_no_lcd.dts

Press enter to save this change, then doppelpress ESC until you are opted for saving the configuration. Select Save. Menuconfig will leave and you should now have configured your Acqua A5 with the correct LCD setting.

We have configured Buildroot to use the Buildroot Cache to speed up the next build process. This will take up some disk space but will greately increase the next build process.

If you don't want to create the AT91Bootloader, you can disable it (User-proviced options on the first page at the lower end of the list). 

You can customize the configuration with:
> make menuconfig

If you want to customize the linux kernel configuration:
> make linux-menuconfig

## Build

To build everything just run:
> make

This will take some time (depending on your machine a few hours!) and will produce these files in buildroot-at91/output/images:
* at91bootstrap.bin
* rootfs.tar
* zImage
* acme-acqua_lcd_70.dtb

Prepare a SD-card as described by Acmesystems.it (http://www.acmesystems.it/microsd_format). Entering the SD card in your linux system should automatically mount KERNEL and rootfs (perhaps a little bit different).

Copy at91bootstrap.bin as boot.bin (important, as ROMBoot searches for a file named boot.bin), zImage and acme-acqua_lcd_70.dtb to the first partition named KERNEL (you should be in the ~/Buildroot/buildroot-at91 folder now)
> sudo cp output/images/at91bootstrap.bin /[some folders in between perhaps]/KERNEL/boot.bin
> sudo cp output/images/zImage /[some folders in between perhaps]/KERNEL/zImage
> sudo cp output/images/acme-acqua_lcd_70.dtb /[some folders in between perhaps]/KERNEL/at91-sama5d3_acqua.dtb

Now extract the rootfs to the second partition:
> sudo tar xvf output/images/rootfs.tar -C /[some folders in between perhaps]/rootfs

Voila, you hopefully have a working Acqua A5 with 7 inch LCD (or one of the other sizes) with Qt5 and various tools. Now make sure that the Kernel and Buildroot configuration matches your need by navigating through the options.

Have fun and good luck!
