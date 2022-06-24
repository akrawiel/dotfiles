#!/bin/bash

sudo cpupower frequency-set -g performance
sudo cpupower frequency-set -u 3.9GHz
sudo tee /sys/firmware/acpi/platform_profile > /dev/null << EOF
performance
EOF
