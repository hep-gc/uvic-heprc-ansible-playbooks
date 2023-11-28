#!/bin/bash

PATH="$1"
METHOD=$2
endpoint=$3
bucket=$4
chksum="0"

calculate_checksum()
{
    local path=$1
    local method=$2
    local endpoint=$3
    local bucket=$4
    local chksumarray=( 0 0 )
    local chksum=0

    case "$method" in
        adler32) chksumarray=($(aws s3 cp s3://"${path}" - --endpoint-url="${endpoint}"| xrdadler32))
                 ;;
        md5) chksumarray=($(aws s3 cp s3://"${path}" - --endpoint-url="${endpoint}" | md5sum))
             ;;
    esac
    chksum=${chksumarray[0]}
    echo $chksum
    put_checksum $method $path $endpoint $chksum
}

get_checksum()
{
    local path=$1
    local method=$2
    local endpoint=$3
    local bucket=$4
    
    local chksum=$(python3 /tmp/checksum.py checksums get -f $url -t $method)
    if [ "$chksum" == "None" ];
    then
        chksum=$(calculate_checksum $path $method $endpoint $bucket)
    fi

    echo $chksum

}

put_checksum()
{
    local method=$1
    local path=$2
    local endpoint=$3
    local chksum=$4

    python3 /tmp/checksum.py checksums put --checksum=$chksum -f $path -t $method

}

chksum=$(get_checksum $PATH $METHOD $endpoint $bucket)
echo -e ">>>>> HASH $chksum\n"
exit
