#!/bin/bash

apt-get remove --purge -y \
    firefox \
    thunderbird \
    ubuntu-web-launchers \
    rhythmbox


# set the icons from the favorites bar. Filenames: ls /usr/share/applications
gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

# dash properties - https://linuxconfig.org/how-to-customize-dock-panel-on-ubuntu-18-04-bionic-beaver-linux
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
#gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
