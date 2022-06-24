#!/bin/bash

sudo cpupower frequency-set -g powersave
sudo cpupower frequency-set -u 1.6GHz
sudo tee /sys/firmware/acpi/platform_profile > /dev/null << EOF
balanced
EOF
