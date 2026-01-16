#!/bin/bash
if [ -z $1 ]; then echo "buh"
else
    CONTEXT="$(hyprctl clients | grep -m 1 -B 4 "class: $1")"
    if [[ $CONTEXT ]]; then
#         WORKSPACE_CTX="$(echo "$CONTEXT" | grep -Eo "workspace:\s+[0-9]+")"
#         WORKSPACE="$(echo $WORKSPACE_CTX | grep -Eo "[0-9]+")"
#         hyprctl dispatch workspace $WORKSPACE
        hyprctl dispatch focuswindow class:$1
    else
        $2
    fi
fi
