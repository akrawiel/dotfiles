function gigaupdate --wraps='paru -Syu --noconfirm --skipreview' --description 'alias gigaupdate paru -Syu --noconfirm --skipreview'
  paru -Syu --noconfirm --skipreview $argv; 
end
