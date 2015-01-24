#!/bin/sh
#Directory contains the target rootfs
TARGET_ROOTFS_DIR=$1

#Board hostname
filename=$TARGET_ROOTFS_DIR/etc/hostname
echo acqua > $filename

#Default name servers
filename=$TARGET_ROOTFS_DIR/etc/resolv.conf
echo nameserver 8.8.8.8 > $filename
echo nameserver 8.8.4.4 >> $filename

#Default network interfaces
filename=$TARGET_ROOTFS_DIR/etc/network/interfaces
echo allow-hotplug eth0 >> $filename
echo iface eth0 inet dhcp >> $filename
#eth0 MAC address
echo hwaddress ether 00:04:25:12:34:56 >> $filename

#Set the the debug port
#filename=$TARGET_ROOTFS_DIR/etc/inittab
#echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> $filename

#Set rules to change wlan dongles
filename=$TARGET_ROOTFS_DIR/etc/udev/rules.d/70-persistent-net.rules
echo SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="*", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wlan*", NAME="wlan0" > $filename

#microSD partitions mounting
filename=$TARGET_ROOTFS_DIR/etc/fstab
echo /dev/mmcblk0p1 /boot vfat noatime 0 1 > $filename
echo /dev/mmcblk0p2 / ext4 noatime 0 1 >> $filename
#echo /dev/mmcblk0p3 /media/data ext4 noatime 0 1 >> $filename
echo proc /proc proc defaults 0 0 >> $filename
echo none /sys sysfs defaults 0 0 >> $filename
echo none /proc/bus/usb usbfs defaults 0 0 >> $filename
echo devtps /dev/pts devpts defaults 0 0 >> $filename
echo tmpfs /dev/shm tmpfs defaults 0 0 >> $filename

#Add the standard Debian non-free repositories useful to load
#closed source firmware (i.e. WiFi dongle firmware)
filename=$TARGET_ROOTFS_DIR/etc/opkg.conf
echo src/gz snapshots http://downloads.openwrt.org/snapshots/trunk/ar71xx/packages > $filename
echo dest root / >> $filename
echo dest ram /tmp >> $filename
echo lists_dir ext /var/opkg-lists >> $filename
echo option overlay_root /overlay >> $filename

