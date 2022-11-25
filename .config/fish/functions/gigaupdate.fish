function gigaupdate --wraps='yay -Syu --noconfirm' --description 'alias gigaupdate yay -Syu --noconfirm'
  yay -Syu --noconfirm $argv; 
end
