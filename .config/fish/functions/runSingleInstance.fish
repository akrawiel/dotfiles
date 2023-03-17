function runSingleInstance
  set -l argCount (count $argv)

  if test $argCount -eq 2
    set -f condition $argv[2]
  else if test $argCount -eq 1
    set -f condition $argv[1]
  else
    return 1
  end

  set -l result (pgrep -f "$condition")
  if test -z "$result"
    eval "$argv[1]&"
  end
end
