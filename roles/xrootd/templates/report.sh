#!/bin/bash
get_report()
{
    local values=$(s3-storage-stats reports -n "{{ server_type }}")

    echo $values
}

get_report
exit
