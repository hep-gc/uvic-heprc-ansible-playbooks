#!/bin/sh
logfile="/var/log/xrootd/{{server_type}}/tpc.log"

echo "+++++++++++++++++++++++++++++++++++++" | tee -a $logfile 2>&1
echo -e "\nDATE: $(date)" | tee -a $logfile 2>&1
echo "All args:" | tee -a $logfile 2>&1
printf '%s\n' "$*" | tee -a $logfile 2>&1

OTHERARGS=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -S) 
      STREAMS=$2
      echo "Wrote $2 to STREAMS" | tee -a $logfile 2>&1
      shift
      shift
    ;;
    *://*)
      echo "Wrote $1 to SRC" | tee -a $logfile 2>&1
      SRC="$1"
      shift
    ;;
    /*)
      DST="$1"
      echo "Wrote $1 to DST" | tee -a $logfile 2>&1
      shift
    ;;
    *)
      OTHERARGS+=("$1")
      shift
    ;;
  esac
done >> $logfile 2>&1


echo "Stream: $STREAMS" | tee -a $logfile 2>&1
echo "Source: $SRC" | tee -a $logfile 2>&1
echo "Destination: $DST" | tee -a $logfile 2>&1
echo "Other Args: ${OTHERARGS[@]}" | tee -a $logfile 2>&1

echo "xrdcp --server -S $STREAMS $SRC - | s3cmd -c /etc/xrootd/s3cfg put - s3:/$DST" | tee -a $logfile 2>&1

xrdcp --server -S $STREAMS $SRC - | s3cmd -c /etc/xrootd/s3cfg put - s3:/$DST
