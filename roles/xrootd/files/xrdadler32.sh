#!/bin/sh

file=$1
davix-get --s3accesskey $AWS_ACCESS_KEY_ID \
          --s3secretkey $AWS_SECRET_ACCESS_KEY \
          --s3alternate https://${XRDXROOTD_PROXY}$file | xrdadler32 | awk '{print $1}'
