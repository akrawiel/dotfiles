function fish_prompt
  set -f git_branch_name (git rev-parse --abbrev-ref HEAD 2> /dev/null)

  set -f blue (set_color blue)
  set -f green (set_color green)
  set -f red (set_color red)
  set -f normal (set_color normal)

  set -l cwd $blue(basename (prompt_pwd))

  if test -n "$git_branch_name"
    set git_info $green(echo $git_branch_name)
    set git_info " $git_info"

    set -f git_dirty (git status -s --ignore-submodules=dirty 2> /dev/null)

    if test -n "$git_dirty"
      set -l dirty $red(echo "×")
      set git_info "$git_info $dirty"
    end
  end

  echo -n -s $cwd $git_info $normal ' ' 
end
