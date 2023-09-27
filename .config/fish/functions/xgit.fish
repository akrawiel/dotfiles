function xgit
  set option $argv[1]
  set arg1 $argv[2]

  switch $option
    case delete-branches db
      set value (default "$arg1" (git branch --show-current))
      git branch --merged | rg -v "^\*|$value" | xargs -r git branch -d
    case prettier-diff prettier pd
      set value (default "$arg1" (git branch --show-current))
      git diff --name-only --diff-filter=ABCMRTUX "origin/$value" | sed 's/^app\///' | rg -e '.(j|t)sx?$' | xargs yarn prettier --write
    case eslint-diff eslint ed
      set value (default "$arg1" (git branch --show-current))
      git diff --name-only --diff-filter=ABCMRTUX "origin/$value" | sed 's/^app\///' | rg -e '.(j|t)sx?$' | xargs yarn eslint --fix
    case "*"
      echo -s (set_color red) "COMMAND UNKNOWN " (set_color normal) $option
  end
end
