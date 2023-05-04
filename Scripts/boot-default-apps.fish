#!/usr/bin/env fish

runSingleInstance 'firefox'
runSingleInstance 'slack -s'
runSingleInstance '/var/lib/flatpak/exports/bin/com.slack.Slack' 'slack'
runSingleInstance 'thunderbird'
runSingleInstance 'logseq' 'Logseq'
