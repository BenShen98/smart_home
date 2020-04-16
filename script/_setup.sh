#!/bin/bash

# variable setup
_REMOTE=root@192.168.0.42
_WKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
_SHDIR=$_WKDIR/script
_CFDIR=$_WKDIR/config
_DNDIR=$_WKDIR/down
_DEV=1

# create dir
[ -d "$_DNDIR" ] || mkdir "$_DNDIR"