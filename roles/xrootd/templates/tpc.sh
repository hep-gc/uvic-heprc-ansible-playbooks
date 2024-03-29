#!/bin/bash
logfile="/var/log/xrootd/{{server_type}}/tpc.log"

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
done >> $logfile 2>&1

echo "Streams: $STREAMS" | tee -a $logfile 2>&1
echo "Source: $SRC" | tee -a $logfile 2>&1
echo "Destination: $DST" | tee -a $logfile 2>&1
echo "Other Args: ${OTHERARGS[@]}" | tee -a $logfile 2>&1
      
if [[ "$SRC" == *"root"* ]]
then
  echo "Running: xrdcp --server -S $STREAMS $SRC $DST"
  xrdcp --server -S $STREAMS $SRC $DST
elif [[ "$SRC" == *"https"* ]] || [[ "$SRC" == *"davs"* ]]
then
 echo "Running: gfal-copy -n $STREAMS $SRC $DST"
 gfal-copy -n $STREAMS $SRC $DST
fi  >> $logfile 2> >(tee -a $logfile >&2)
