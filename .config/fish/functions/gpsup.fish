function gpsup --wraps='git push --set-upstream origin (git_branch_name)' --description 'alias gpsup git push --set-upstream origin (git_branch_name)'
  git push --set-upstream origin (git_branch_name) $argv; 
end
