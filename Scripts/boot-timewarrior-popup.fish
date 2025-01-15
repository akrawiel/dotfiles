#!/bin/bash

if type -q hyprctl
  hyprctl dispatch exec "[float; size 50% 50%] kitty -e timewarrior-popup.tsx"
else
  kitty --class KittyPopup -e timewarrior-popup.tsx
end

