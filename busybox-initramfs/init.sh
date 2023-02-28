#!/bin/busybox sh
/bin/busybox mkdir -p /etc /proc /root /sbin /sys /usr/bin /usr/sbin
/bin/busybox --install /bin
busybox mount -t proc proc /proc
busybox mount -t sysfs sys /sys
busybox mdev -s
exec sh
