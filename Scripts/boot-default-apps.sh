#!/bin/zsh

[[ `ps ax -o cmd | rg -e firefoxdeveloperedition$ | wc -l` -eq 0 ]] && firefox-developer-edition &
[[ `ps ax -o pid,cmd | rg -e slack/slack | wc -l` -le 1 ]] && slack &
[[ `ps ax -o pid,cmd | rg -e evolution$ | wc -l` -eq 0 ]] && evolution &
[[ `ps ax -o pid,cmd | rg -e ferdi/ferdi | wc -l` -le 1 ]] && ferdi &
[[ `ps ax -o cmd | rg -e ^smplayer$ | wc -l` -eq 0 ]] && smplayer &
