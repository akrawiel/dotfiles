#!/usr/bin/env fish

runSingleInstance 'kitty -c ~/.config/kitty/kitty.notes.conf --class xpad env NVIM_APPNAME=nvim.notes nvim ~/.config/nvim.notes.data/notes.md' 'xpad'
#runSingleInstance 'xpad -s -N' 'xpad'

runSingleInstance 'firefox'
runSingleInstance 'slack -s'
runSingleInstance '/var/lib/flatpak/exports/bin/com.slack.Slack' 'slack'
runSingleInstance 'thunderbird'
runSingleInstance '/var/lib/flatpak/exports/bin/org.ferdium.Ferdium' 'ferdium'
runSingleInstance 'ferdium'
