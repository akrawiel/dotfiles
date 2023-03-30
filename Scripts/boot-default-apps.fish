#!/bin/fish

runSingleInstance 'firefox-developer-edition'
runSingleInstance 'slack -s'
runSingleInstance 'thunderbird-beta'
runSingleInstance 'kitty --class TodoDaily -e /usr/bin/nvim "$HOME/Dropbox/Documents/OrgSync/Todo Daily.org"' 'TodoDaily'
