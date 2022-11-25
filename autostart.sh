#!/bin/sh

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

export TERMINAL=kitty

setxkbmap pl -option caps:ctrl_modifier &
xset s off &
dunst &
numlockx &
flameshot &
redshift-gtk &
nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
solaar -w hide &
xfsettingsd --daemon &
xfce4-power-manager --daemon &
nitrogen --restore &
emacs --daemon &
dropbox &
syncthing-gtk -m &
joplin sync &
dockd --daemon &
