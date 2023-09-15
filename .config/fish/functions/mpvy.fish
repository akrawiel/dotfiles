function mpvy --wraps='mpv --ytdl-format="bestvideo[height<=720][fps<=30]+bestaudio"' --description 'alias mpvy mpv --ytdl-format="bestvideo[height<=720][fps<=30]+bestaudio"'
  mpv --ytdl-format="bestvideo[height<=720][fps<=30]+bestaudio" $argv
        
end
