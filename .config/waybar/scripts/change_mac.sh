#!/bin/bash

rand_ip="$(echo -n 82:9c:65; dd bs=1 count=3 if=/dev/random 2>/dev/null | hexdump -v -e '/1 ":%02X"')"

sudo ip link set dev wlan0 down
sudo ip link set dev wlan0 address $rand_ip
sleep 1
sudo ip link set dev wlan0 up
