#!/bin/zsh

name="$(cat ~/Scripts/commands.json | jq -r 'sort_by(.name) | sort_by(.type) | .[] | .type + ": " + .name' | rofi -i -dmenu)"

if [ -n "$name" ]
then
  command1='.[] | select ((.type + ": " + .name) == "'
  command2='") | .script'
  spawnScript=$(cat ~/Scripts/commands.json | jq -r "$command1$name$command2")
  echo "$spawnScript"
  zsh -c "$spawnScript"
fi
