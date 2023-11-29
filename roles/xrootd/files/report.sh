#!/bin/bash
get_report()
{
    local values=$(python3 /tmp/storage_stats.py reports)

    echo $values
}

get_report
exit
