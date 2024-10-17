function runSingleInstance
  set -l argCount (count $argv)

  if test $argCount -eq 2 -o 3
    set -f condition $argv[2]
  else if test $argCount -eq 1
    set -f condition $argv[1]
  else
    return 1
  end

  if test $argCount -eq 3
    if test $argv[3] = "exact"
      set -f result (pgrep -x "$condition")
    else
      return 1
    end
  else
    set -f result (pgrep -f "$condition")
  end

  if test -z "$result"
    eval "$argv[1]&"
  end
end
