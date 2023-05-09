function fish_command_not_found
  echo -s -n (set_color red) "COMMAND NOT FOUND"  
  echo (set_color normal) $argv
end
