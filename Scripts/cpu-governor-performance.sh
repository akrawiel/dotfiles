#!/bin/bash

governor_data="governor=\"performance\"
max_freq=\"3.9GHz\""

echo "$governor_data" | tee /etc/default/cpupower
systemctl restart cpupower
