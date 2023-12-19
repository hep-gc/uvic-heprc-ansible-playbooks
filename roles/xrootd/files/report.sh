#!/bin/bash
get_report()
{
    local values=$(s3-storage-stats reports)

    echo $values
}

get_report
exit
