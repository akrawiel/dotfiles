#!/bin/bash

if type -q hyprctl
  hyprctl dispatch exec "[float; size 50% 50%] kitty -e media-dashboard.tsx"
else
  kitty --class KittyPopup -e media-dashboard.tsx
end
