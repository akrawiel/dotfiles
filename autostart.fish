#!/bin/fish

set -l keyringVariables (string split ' ' (/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh))

for variable in $keyringVariables
  set -l splitVariable (string split = $variable)
  eval "set -Ux $splitVariable[1] $splitVariable[2]"
end

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk
xset s off

runSingleInstance 'numlockx' 'numlockx'
runSingleInstance 'flameshot' 'flameshot'
runSingleInstance 'redshift -l 0:0 -t 3000:3000 -r' 'redshift'
runSingleInstance 'nm-applet' 'nm-applet'
runSingleInstance '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1' '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'
runSingleInstance '/usr/libexec/polkit-gnome/polkit-gnome-authentication-agent-1' '/usr/libexec/polkit-gnome/polkit-gnome-authentication-agent-1'
runSingleInstance '/usr/libexec/polkit-gnome-authentication-agent-1' '/usr/libexec/polkit-gnome-authentication-agent-1'
runSingleInstance '/usr/lib/geoclue-2.0/demos/agent' '/usr/lib/geoclue-2.0/demos/agent'
runSingleInstance '/usr/libexec/geoclue-2.0/demos/agent' '/usr/libexec/geoclue-2.0/demos/agent'
runSingleInstance 'solaar -w hide' 'solaar'
runSingleInstance 'xfsettingsd --daemon' 'xfsettingsd'
runSingleInstance 'syncthing-gtk -m' 'syncthing-gtk'
runSingleInstance 'me.kozec.syncthingtk -m' 'syncthing-gtk'
runSingleInstance 'syncthingtray' 'syncthingtray'
runSingleInstance 'picom' 'picom'
runSingleInstance 'playerctld' 'playerctld'
runSingleInstance 'xautolock -time 10 -locker "i3lock -t -i ~/Pictures/stressful.png ‐n" -detectsleep' 'xautolock'
