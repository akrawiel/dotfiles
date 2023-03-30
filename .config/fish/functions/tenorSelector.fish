function tenorSelector
  set -f result (cat "$HOME/tenor-commands" | rofi -i -dmenu)

  if test -n "$result"
    echo $result | cut -d"|" -f2 | string collect | string trim | xclip -selection clipboard
    set -l gifname (echo $result | cut -d"|" -f1 | string collect | string trim)
    awesome-client "n = require('naughty') n.notify({ bg = n.config.presets.low.bg, title = 'GIF Selected', text = '$gifname' })"
  end
end
