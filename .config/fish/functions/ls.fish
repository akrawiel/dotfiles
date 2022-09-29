function ls --wraps='exa --color always --icons' --description 'alias ls exa --color always --icons'
  exa --color always --icons $argv; 
end
