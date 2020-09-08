#!/bin/bash

. constants.sh
check_is_root

# Configure mount points, home and locale
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C

# Set a custom hostname
echo "ufs" > /etc/hostname
echo "ufs" > /etc/mybuild

# Configure apt sources.list
cat <<EOF > /etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
EOF

# Install systemd
apt-get update
apt-get install -y systemd-sysv

# Configure machine-id and divert
dbus-uuidgen > /etc/machine-id
ln -fs /etc/machine-id /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# Install packages needed for Live System
apt-get install -y \
    ubuntu-standard \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    network-manager \
    resolvconf \
    net-tools \
    wireless-tools \
    wpagui \
    locales \
    linux-generic

# Graphical installer
apt-get install -y \
    ubiquity \
    ubiquity-casper \
    ubiquity-frontend-gtk \
    ubiquity-slideshow-ubuntu \
    ubiquity-ubuntu-artwork

# Install window manager
apt-get install -y \
    plymouth-theme-ubuntu-logo \
    ubuntu-gnome-desktop \
    ubuntu-gnome-wallpapers

# Install useful applications
apt-get install -y \
    terminator \
    apt-transport-https \
    curl \
    vim \
    nano \
    less

# My Apps
./z_vscode.sh
# ./z_googlechrome.sh
./z_bravebrowser.sh
./z_jdk8.sh
./z_remmina.sh
./z_utils.sh
./z_gnomesettings.sh

# My cleanup
./z_cleanup.sh

# upgrade everything
apt-get full-upgrade -y

# Remove unused packages
apt-get autoremove -y

# Reconfigure packages
dpkg-reconfigure locales
dpkg-reconfigure resolvconf
cat <<EOF > /etc/NetworkManager/NetworkManager.conf
[main]
rc-manager=resolvconf
plugins=ifupdown,keyfile
dns=dnsmasq

[ifupdown]
managed=false
EOF
dpkg-reconfigure network-manager

# Cleanup the chroot environment
truncate -s 0 /etc/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
apt-get clean
rm -rf /tmp/* ~/.bash_history
umount /proc
umount /sys
umount /dev/pts
export HISTSIZE=0

# Exit the chroot environment
echo ""
echo "Done with chroot. Type 'exit' and continue with next step"
