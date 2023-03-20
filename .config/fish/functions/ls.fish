function ls --wraps='exa --color always --icons' --wraps='nnn -de' --description 'alias ls nnn -de'
  nnn -de $argv
        
end
