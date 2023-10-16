function gandalf --wraps=mpv\ --loop\ \'https://www.youtube.com/watch\?v=BBGEG21CGo0\' --description gandalf
  mpv --loop --ytdl-format="bestvideo[height<=720][fps<=30]+bestaudio" 'https://www.youtube.com/watch?v=BBGEG21CGo0' $argv &;
  disown;
end
