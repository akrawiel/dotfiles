function tserr
	nr tsc 2> /dev/null | rg 'error TS' | sed -E 's/([^:]+):.+/\1/'
end
