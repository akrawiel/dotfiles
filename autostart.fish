#!/bin/fish

set -l keyringVariables (string split ' ' (/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh))

for variable in $keyringVariables
  set -l splitVariable (string split = $variable)
  eval "set -Ux $splitVariable[1] $splitVariable[2]"
end

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk
xset s off
xpad -s -N &

runSingleInstance 'numlockx'
runSingleInstance 'flameshot'
runSingleInstance 'redshift-gtk'
runSingleInstance 'nm-applet'
runSingleInstance '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'
runSingleInstance 'solaar -w hide'
runSingleInstance 'xfsettingsd --daemon'
runSingleInstance 'xfce4-power-manager --daemon'
runSingleInstance 'syncthing-gtk -m'
runSingleInstance 'dockd --daemon'
runSingleInstance 'keepassxc'
runSingleInstance 'synology-drive' 'SynologyDrive'
runSingleInstance 'picom'
runSingleInstance '/usr/lib/geoclue-2.0/demos/agent'
