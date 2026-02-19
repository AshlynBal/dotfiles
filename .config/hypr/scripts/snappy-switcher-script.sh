#!/bin/bash
dir=$1
amount=$2

if [[ -z $amount ]]; then
    amount=1
fi

# echo $dir $amount

for i in $(seq 1 $amount); do
#     echo $dir
#     echo "snappy-switcher $dir"
    snappy-switcher $dir
done
