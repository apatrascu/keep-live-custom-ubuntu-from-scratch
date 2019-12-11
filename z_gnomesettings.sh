#!/bin/bash

#TODO - fix this
UFS_USER="gdm"

# set the icons from the favorites bar. Filenames: ls /usr/share/applications

sudo su gdm -c 'gsettings set org.gnome.shell favorite-apps "[\"brave-browser.desktop\", \"org.gnome.Nautilus.desktop\", \"org.gnome.Terminal.desktop\"]"'

# dash properties - https://linuxconfig.org/how-to-customize-dock-panel-on-ubuntu-18-04-bionic-beaver-linux
sudo su gdm -c 'gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false'
sudo su gdm -c 'gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM'
sudo su gdm -c 'gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED'
sudo su gdm -c 'gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24'
#sudo su gdm -c 'gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true'
