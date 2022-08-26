function gstaa --wraps='git stash apply' --description 'alias gstaa git stash apply'
  git stash apply $argv; 
end
