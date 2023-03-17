#!/bin/fish

set -l keyringVariables (string split ' ' (/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh))

for variable in $keyringVariables
  set -l splitVariable (string split = $variable)
  eval "set -Ux $splitVariable[1] $splitVariable[2]"
end

function run
  set -l result (pgrep -f "$argv[1]")
  if test -z "$result"
    eval "$argv[1]&"
  end
end

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk
xset s off
nitrogen --restore

run 'numlockx'
run 'flameshot'
run 'redshift-gtk'
run 'nm-applet'
run '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'
run 'solaar -w hide'
run 'xfsettingsd --daemon'
run 'xfce4-power-manager --daemon'
run 'dropbox'
run 'syncthing-gtk -m'
run 'dockd --daemon'
run 'keepassxc'
