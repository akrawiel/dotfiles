function gpsup --wraps='git push -u origin (git rev-parse --abrev-ref HEAD)' --wraps='git push -u origin (git rev-parse --abbrev-ref HEAD)' --description 'alias gpsup git push -u origin (git rev-parse --abbrev-ref HEAD)'
  git push -u origin (git rev-parse --abbrev-ref HEAD) $argv; 
end
