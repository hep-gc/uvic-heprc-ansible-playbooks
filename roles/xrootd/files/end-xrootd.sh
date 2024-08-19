#!/bin/bash
for i in $(pgrep -f "_server-")
do 
  kill -9 $i
done

#checkpid=$(pgrep -f "check-config.sh")
#kill  $(ps -o pid= --ppid "$checkpid" 2>/dev/null) &>/dev/null
#kill  $checkpid &>/dev/null

#checkpid=$(pgrep -f "collect-rootfiles.sh")
#kill  $(ps -o pid= --ppid "$checkpid" 2>/dev/null) &>/dev/null
#kill  $checkpid &>/dev/null

