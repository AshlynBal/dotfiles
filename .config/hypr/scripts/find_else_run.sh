#!/bin/bash
if [ -z $1 ]; then echo "buh"
else
class="$1"
program="$2"
workspace="$3"
echo "workspace $workspace"

if [ -n $workspace ]; then
    hyprctl dispatch focuswindow class:"$class" | grep -q ok || hyprctl dispatch exec [workspace "$workspace"] "$program"
else
    hyprctl dispatch focuswindow class:"$class" | grep -q ok || "$program"
fi
fi
