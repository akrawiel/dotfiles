function mpa --wraps='mpv --ytdl-format=bestaudio/best' --description 'alias mpa mpv --ytdl-format=bestaudio/best'
  mpv --ytdl-format=bestaudio/best $argv; 
end
