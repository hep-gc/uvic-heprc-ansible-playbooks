<<<<<<< HEAD
#!/bin/bash
logfile="/var/log/xrootd/tpc/tpc.log"
_debug=0

if [ $_debug -eq 1 ];
then 
 echo -e "\nDATE: $(date)" | tee -a $logfile 2>&1
 echo "All args:" | tee -a $logfile 2>&1
 printf '%s\n' "$*" | tee -a $logfile 2>&1
fi
=======
#!/bin/sh
set -- `getopt S: -S 1 $*`
>>>>>>> 0eb421dbf83079683d193848ec5bbdeb6214dc84

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
<<<<<<< HEAD
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
=======
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
>>>>>>> 0eb421dbf83079683d193848ec5bbdeb6214dc84
  esac
done >> $logfile 2>&1

if [ $_debug -eq 1 ];
then 
 echo "Streams: $STREAMS" | tee -a $logfile 2>&1
 echo "Source: $SRC" | tee -a $logfile 2>&1
 echo "Destination: $DST" | tee -a $logfile 2>&1
 echo "Other Args: ${OTHERARGS[@]}" | tee -a $logfile 2>&1
fi
      
if [[ "$SRC" == *"root"* ]]
then
  echo "Running: /usr/bin/xrdcp --server -S $STREAMS $SRC $DST"
  /usr/bin/xrdcp --server -S $STREAMS $SRC $DST
elif [[ "$SRC" == *"https"* ]] || [[ "$SRC" == *"davs"* ]]
then
 echo "Running: /usr/bin/gfal-copy -n $STREAMS $SRC $DST"
 /usr/bin/gfal-copy -n $STREAMS $SRC $DST
fi  >> $logfile 2> >(tee -a $logfile >&2)

<<<<<<< HEAD
=======
/bin/xrdcp -d3 --server -S $STREAMS $SRC $DST
>>>>>>> 0eb421dbf83079683d193848ec5bbdeb6214dc84
