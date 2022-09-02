function gtl --wraps='git tag --sort=-v:refname -n -l' --description 'alias gtl git tag --sort=-v:refname -n -l'
  git tag --sort=-v:refname -n -l $argv; 
end
