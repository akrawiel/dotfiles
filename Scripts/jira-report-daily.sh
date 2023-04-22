#!/bin/fish

kitty -e fish -c "timew stop; jira-report-daily.mjs; sleep 3"
