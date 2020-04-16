#!/bin/bash

# RUN ON REMOTE
# Take $@ as input list for volumes 
targets=""

for config in "$@"; do
    target="$(balena volume ls --format '{{ .Mountpoint }}' --filter "name=${config}" --filter "dangling=false")"
    targets="$targets $target"
done

# create tar and send to stdout
echo $targets | sed 's/ /\n/g' | tar -cT -