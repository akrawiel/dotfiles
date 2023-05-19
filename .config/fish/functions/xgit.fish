function xgit
  set -f option $argv[1]
  echo $PWD

  switch $option
    case delete-branches db
      git branch --merged | rg -v '^\*|master' | xargs -r git branch -d
    case prettier-diff prettier pd
      git diff --name-only --diff-filter=ABCMRTUX origin/master | sed 's/^app\///' | rg -e '.(j|t)sx?$' | xargs yarn prettier --write
    case eslint-diff eslint ed
      git diff --name-only --diff-filter=ABCMRTUX origin/master | sed 's/^app\///' | rg -e '.(j|t)sx?$' | xargs yarn eslint --fix
    case "*"
      echo -s (set_color red) "COMMAND UNKNOWN " (set_color normal) $option
  end
end
