#!/bin/fish

set -l f "$argv[1]"

bat -f --style=plain "$f"
