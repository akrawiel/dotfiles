#!/bin/fish

set -l keyringVariables (string split ' ' (/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh))

for variable in $keyringVariables
  set -l splitVariable (string split = $variable)
  eval "set -Ux $splitVariable[1] $splitVariable[2]"
end

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk
xset s off

runSingleInstance 'numlockx'
runSingleInstance 'flameshot'
runSingleInstance 'redshift-gtk'
runSingleInstance 'nm-applet'
runSingleInstance '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'
runSingleInstance '/usr/libexec/polkit-gnome/polkit-gnome-authentication-agent-1'
runSingleInstance '/usr/lib/geoclue-2.0/demos/agent'
runSingleInstance '/usr/libexec/geoclue-2.0/demos/agent'
runSingleInstance 'solaar -w hide'
runSingleInstance 'xfsettingsd --daemon'
runSingleInstance 'syncthing-gtk -m'
runSingleInstance 'me.kozec.syncthingtk -m' 'syncthing-gtk'
runSingleInstance 'keepassxc'
runSingleInstance 'picom'
runSingleInstance 'xscreensaver' 'xscreensaver'
runSingleInstance 'playerctld'
