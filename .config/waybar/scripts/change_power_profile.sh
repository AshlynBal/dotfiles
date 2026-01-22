#!/bin/bash
POWER_PROFILE=$(powerprofilesctl get)
NEW_PROFILE=$1

function notif() {
    notify-send -u normal "$1"
}

if [ "$POWER_PROFILE" = "$NEW_PROFILE" ]; then
    notif "Already on $POWER_PROFILE!"
    return 0
else

    notif "Power profile set to $NEW_PROFILE"


fi
