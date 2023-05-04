function fish_prompt
  set -f blue (set_color blue)
  set -f green (set_color green)
  set -f red (set_color red)
  set -f normal (set_color normal)

  set -f git_branch_name (git rev-parse --abbrev-ref HEAD 2> /dev/null)
  set -f cwd (basename (prompt_pwd))
  set -f git_info ''

  if test -n "$git_branch_name"
    set git_info (echo -n -s ' ' $green $git_branch_name)

    set -f git_dirty (git status -s --ignore-submodules=dirty 2> /dev/null)

    if test -n "$git_dirty"
      set git_info (echo -n -s $git_info ' ' $red '×')
    end
  end

  echo -n -s $blue $cwd $git_info $normal ' ' 
end
