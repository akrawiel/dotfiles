#!/bin/bash

if pgrep xautolock
  xautolock -locknow
else if type -q loginctl
  loginctl lock-session
  if type -q hyprlock
    pidof hyprlock || hyprlock
  end
end
