#!/bin/bash

# Example usage: "./find_program.sh discord" returns the workspace discord is in. Returns -1 if not found.

CONTEXT="$(hyprctl clients | grep -m 1 -B 4 "class: $1")"
if [[ $CONTEXT ]]; then
    WORKSPACE="$(echo "$CONTEXT" | grep -Eo "workspace:\s+[0-9]+")"
    echo "$(echo $WORKSPACE | grep -Eo "[0-9]+")"
else
    echo "-1"
fi
