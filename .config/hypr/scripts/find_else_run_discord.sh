#!/bin/bash
if [ -z $1 ]; then echo "buh"
else
program="$1"
workspace="$2"
echo "workspace $workspace"

if [ -n $workspace ]; then
    hyprctl dispatch focuswindow class:"$class" | grep -q ok || hyprctl dispatch exec [workspace "$workspace"] "$program"
else
    hyprctl dispatch focuswindow class:"$class" | grep -q ok || "$program"
fi
fi
