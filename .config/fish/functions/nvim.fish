function nvim --wraps='/usr/bin/nvim --listen /tmp/nvimsocket' --description 'alias nvim /usr/bin/nvim --listen /tmp/nvimsocket'
  /usr/bin/nvim --listen /tmp/nvimsocket $argv; 
end
