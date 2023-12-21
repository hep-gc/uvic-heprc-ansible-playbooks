#!/bin/bash

FILEPATH="$1"
METHOD=$2
bucket=$3
chksum="0"

calculate_checksum()
{
    local filepath=$1
    local method=$2
    local bucket=$3
    local chksumarray=( 0 0 )
    local chksum=0

    case "$method" in
        adler32) chksumarray=($(s3cmd get s3://"${bucket}/${filepath}" - --config="/etc/xrootd/s3cfg" | xrdadler32))
                 ;;
        md5) chksumarray=($(s3cmd get s3://"${bucket}/${filepath}" - --config="/etc/xrootd/s3cfg" | md5sum))
             ;;
    esac
    chksum=${chksumarray[0]}
    echo $chksum
    put_checksum $method $filepath $chksum
}

get_checksum()
{
    local filepath=$1
    local method=$2
    local bucket=$3
    
    local chksum=$(s3-storage-stats checksums get -f $filepath -t $method -n "{{ server_type }}")
    if [ "$chksum" == "None" ];
    then
        chksum=$(calculate_checksum $filepath $method $bucket)
    fi

    echo $chksum

}

put_checksum()
{
    local method=$1
    local filepath=$2
    local chksum=$3

    s3-storage-stats checksums put --checksum=$chksum -f $filepath -t $method -n "{{ server_type }}"

}

chksum=$(get_checksum $FILEPATH $METHOD $bucket)
echo -e "$chksum\n"
exit
