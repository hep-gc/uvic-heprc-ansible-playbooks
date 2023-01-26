#!/bin/sh
set -- `getopt S: -S 1 $*`

OTHERARGS=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -S)
      STREAMS=$2
      shift
      shift
    ;;
    *://*)
      SRC="$1"
      shift
    ;;
    /*)
      DST="$1"
      shift
    ;;
    *)
      OTHERARGS+=("$1")
      shift
    ;;
  esac
done

/bin/xrdcp -d3 --server -S $STREAMS $SRC $DST
