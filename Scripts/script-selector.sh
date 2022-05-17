#!/bin/zsh

name="$(cat ~/Scripts/script-commands.json | jq -r '.[] | .name' | rofi -i -dmenu)"

if [ -n "$name" ]
then
  spawnScript=$(cat ~/Scripts/script-commands.json | jq -r ".[] | select (.name == \"$name\") | .script")
  echo "$spawnScript"
  zsh -c "$spawnScript"
fi
