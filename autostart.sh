#!/bin/bash

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

run() {
  if ! pgrep -f "$1";
  then
    "$@"&
  fi
}

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk

run "xset s off"
run "numlockx"
run "flameshot"
run "redshift-gtk"
run "nm-applet"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
run "solaar -w hide"
run "xfsettingsd --daemon"
run "xfce4-power-manager --daemon"
run "dropbox"
run "syncthing-gtk -m"
run "dockd --daemon"
run "keepassxc"
