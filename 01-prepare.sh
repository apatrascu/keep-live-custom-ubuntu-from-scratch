#!/bin/bash

. constants.sh

check_is_root

# Prerequisites
apt-get install -y \
    binutils \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools

mkdir $HOME/live-ubuntu-from-scratch

# Bootstrap and configure ubuntu
debootstrap \
   --arch=amd64 \
   --variant=minbase \
   bionic \
   $HOME/live-ubuntu-from-scratch/chroot \
   http://us.archive.ubuntu.com/ubuntu/
mount --bind /dev $HOME/live-ubuntu-from-scratch/chroot/dev
mount --bind /run $HOME/live-ubuntu-from-scratch/chroot/run

cp *.sh $HOME/live-ubuntu-from-scratch/chroot/

chroot $HOME/live-ubuntu-from-scratch/chroot
