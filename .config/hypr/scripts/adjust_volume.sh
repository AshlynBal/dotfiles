#!/bin/bash

# Define variables
vol_adjustment=$1
orig_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "[0-9]*\.[0-9]*")

beep() {
    canberra-gtk-play -i audio-volume-change
}

set_volume() {
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ $1
}

if [ -z $1 ]; then
    echo "missing argument 1!"
    exit 1
else
    if [ "$orig_vol" = "0.00" ] && [ "$(echo $vol_adjustment | grep "-")" ]; then
        exit 2
    fi
    # Unmute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    set_volume $vol_adjustment | beep
    final_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "[0-9]*\.[0-9]*")
    # If volume is 0.00, mute
    if [ "$final_vol" = "0.00" ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
    fi
    exit 0
fi
