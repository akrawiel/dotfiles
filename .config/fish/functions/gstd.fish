function gstd --wraps='git stash drop' --description 'alias gstd git stash drop'
  git stash drop $argv; 
end
