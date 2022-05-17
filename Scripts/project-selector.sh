#!/bin/zsh

project="$(cat ~/Projects/spawn-commands.json | jq -r '.[] | .project' | rofi -i -dmenu)"

if [ -n "$project" ]
then
  spawnScript=$(cat ~/Projects/spawn-commands.json | jq -r ".[] | select (.project == \"$project\") | .script")
  echo "$spawnScript"
  zsh "$spawnScript"
fi
