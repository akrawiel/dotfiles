function glo --wraps='git log --oneline --decorate' --description 'alias glo git log --oneline --decorate'
  git log --oneline --decorate $argv; 
end
