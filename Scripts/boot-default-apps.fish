#!/usr/bin/env fish

runSingleInstance 'kitty -c ~/.config/kitty/kitty.notes.conf --class xpad env NVIM_APPNAME=nvim.notes nvim ~/.config/nvim.notes.data/notes.md' 'xpad'

runSingleInstance 'keepassxc' 'keepassxc' 'exact'
runSingleInstance 'snap run spotify' 'spotify' 'flatpak'
runSingleInstance 'firefox' 'firefox'
runSingleInstance 'slack -s' 'slack'
runSingleInstance 'flatpak run com.slack.Slack' 'slack'
runSingleInstance 'thunderbird' 'thunderbird'
runSingleInstance 'flatpak run org.ferdium.Ferdium' 'ferdium'
runSingleInstance 'ferdium' 'ferdium'
