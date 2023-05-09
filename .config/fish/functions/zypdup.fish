function zypdup --wraps='sudo zypper dup' --description 'alias zypdup sudo zypper dup'
  sudo zypper dup $argv
        
end
