#!/bin/bash

. constants.sh
check_is_root

# Prerequisites
apt-get update
apt-get install -y \
    binutils \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools

mkdir $LIVECD_HOME_DIR

# Bootstrap and configure ubuntu
debootstrap \
   --arch=amd64 \
   --variant=minbase \
   bionic \
   $LIVECD_HOME_DIR/chroot \
   http://us.archive.ubuntu.com/ubuntu/
mount --bind /dev $LIVECD_HOME_DIR/chroot/dev
mount --bind /run $LIVECD_HOME_DIR/chroot/run

cp *.sh $LIVECD_HOME_DIR/chroot/

echo ""
echo "Entering CHROOT. Continue with running the next script"

chroot $LIVECD_HOME_DIR/chroot
