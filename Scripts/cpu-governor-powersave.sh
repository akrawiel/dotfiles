#!/bin/bash

governor_data="governor=\"powersave\"
max_freq=\"1.6GHz\""

echo "$governor_data" | tee /etc/default/cpupower
systemctl restart cpupower
