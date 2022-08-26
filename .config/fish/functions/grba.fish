function grba --wraps='git rebase --abort' --description 'alias grba git rebase --abort'
  git rebase --abort $argv; 
end
