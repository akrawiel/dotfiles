function autoumount
  set -f target (findmnt -n -o TARGET "$argv[1]")
  if test -n "$target"
    sudo umount $target
    sudo rmdir $target
    echo "Umounted $argv[1] from $target"
  else
    echo "$argv[1] not mounted"
  end
end
