#!/bin/bash
get_report()
{
    local values=$(python3 /tmp/checksum.py reports storage)

    echo $values
}

get_report
exit
