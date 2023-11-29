#!/bin/bash

FILEPATH="$1"
METHOD=$2
endpoint=$3
bucket=$4
chksum="0"

calculate_checksum()
{
    local filepath=$1
    local method=$2
    local endpoint=$3
    local bucket=$4
    local chksumarray=( 0 0 )
    local chksum=0

    case "$method" in
        adler32) chksumarray=($(aws s3 cp s3://"${bucket}/${filepath}" - --endpoint-url="${endpoint}"| xrdadler32))
                 ;;
        md5) chksumarray=($(aws s3 cp s3://"${bucket}/${filepath}" - --endpoint-url="${endpoint}" | md5sum))
             ;;
    esac
    chksum=${chksumarray[0]}
    echo $chksum
    put_checksum $method $filepath $endpoint $chksum
}

get_checksum()
{
    local filepath=$1
    local method=$2
    local endpoint=$3
    local bucket=$4
    
    local chksum=$(python3 /tmp/storage_stats.py checksums get -f $filepath -t $method)
    if [ "$chksum" == "None" ];
    then
        chksum=$(calculate_checksum $filepath $method $endpoint $bucket)
    fi

    echo $chksum

}

put_checksum()
{
    local method=$1
    local filepath=$2
    local endpoint=$3
    local chksum=$4

    python3 /tmp/storage_stats.py checksums put --checksum=$chksum -f $filepath -t $method

}

chksum=$(get_checksum $FILEPATH $METHOD $endpoint $bucket)
echo -e "$chksum\n"
exit
