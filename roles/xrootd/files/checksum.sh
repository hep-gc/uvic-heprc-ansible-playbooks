i#!/bin/bash

URL="$1"
METHOD=$2
endpoint=$3
chksum="0"

calculate_checksum()
{
    local url=$1
    local method=$2
    local endpoint=$3
    local chksumarray=( 0 0 )
    local chksum=0

    case "$method" in
        adler32) chksumarray=($(aws s3 cp s3://"${url}" - --endpoint-url="${endpoint}"| xrdadler32))
                 ;;
        md5) chksumarray=($(aws s3 cp s3://"${url}" - --endpoint-url="${endpoint}" | md5sum))
             ;;
    esac

    chksum=${chksumarray[0]}
    echo $chksum
}

getchecksum()
{
    local method=$1
    local url=$2
    local endpoint=$3
    local chksum=$(xxx checksums get -c /path/to-config -e $endpoint -u $url -t $method)

    if [ "$chksum" == "None" ];
    then
        chksum=$(calculate_checksum $url $method $endpoint)
    fi
    echo $chksum

    # command: python3 checksum.py put --checksum=92fae96b4910fb18871b94ab4b04e5b4 -e http://206.12.154.92:9000 -u http://206.12.154.92:9000/tpc/cksum8 -t md5

}

putchecksum()
{
    local method=$1
    local url=$2
    local endpoint=$3
    local chksum=$4

    # TODO: finish this function
    # command: python3 checksum.py put --checksum=${checksum} -e ${endpoint} -u ${url} -t md5
}
chksum=$(getchecksum $METHOD $URL $endpoint)
echo -e ">>>>> HASH $chksum\n"
exit