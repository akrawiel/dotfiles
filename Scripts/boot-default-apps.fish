#!/bin/fish

runSingleInstance 'firefox-developer-edition'
runSingleInstance 'slack -s'
runSingleInstance 'evolution'
runSingleInstance 'kitty --class TodoDaily -e /usr/bin/nvim "$HOME/Dropbox/Documents/OrgSync/Todo Daily.org"' 'TodoDaily'
