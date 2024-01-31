function run
	nohup $argv &> /dev/null & disown
end
