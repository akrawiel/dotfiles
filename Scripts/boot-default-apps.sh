#!/bin/zsh

[[ `ps ax -o pid,cmd | rg -e firefox-developer-edition/firefox$ | wc -l` -eq 0 ]] && firefox-developer-edition &
[[ `ps ax -o pid,cmd | rg -e slack/slack | wc -l` -le 1 ]] && slack &
[[ `ps ax -o pid,cmd | rg -e evolution$ | wc -l` -eq 0 ]] && evolution &
[[ `ps ax -o pid,cmd | rg -e alacritty | wc -l` -le 1 ]] && i3-msg 'workspace 1; exec alacritty' &
[[ `ps ax -o pid,cmd | rg -e ferdi/ferdi | wc -l` -le 1 ]] && ferdi &
