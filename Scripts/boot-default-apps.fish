#!/usr/bin/env fish

runSingleInstance 'xpad -s -N' 'xpad'

runSingleInstance 'firefox'
runSingleInstance 'slack -s'
runSingleInstance '/var/lib/flatpak/exports/bin/com.slack.Slack' 'slack'
runSingleInstance 'thunderbird'
runSingleInstance '/var/lib/flatpak/exports/bin/org.ferdium.Ferdium' 'ferdium'
runSingleInstance 'ferdium'
