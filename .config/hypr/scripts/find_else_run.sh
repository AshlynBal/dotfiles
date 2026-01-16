#!/bin/bash
if [ -z $1 ]; then echo "buh"
else
    hyprctl dispatch focuswindow class:$1 | grep -q ok || $2
fi
