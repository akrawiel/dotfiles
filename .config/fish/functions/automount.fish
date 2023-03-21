function automount
  set -f mountname (basename "$argv[1]")
  sudo mkdir "/mnt/$mountname"
  sudo mount "$argv[1]" "/mnt/$mountname"
  echo "Mounted $argv[1] at /mnt/$mountname"
end
