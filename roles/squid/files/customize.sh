#!/bin/bash
#
# Edit customize.sh as you wish to customize squid.conf.
# It will not be overwritten by upgrades.
# See customhelps.awk for information on predefined edit functions.
# In order to test changes to this, run this to regenerate squid.conf:
#       service frontier-squid
# and to reload the changes into a running squid use
#       service frontier-squid reload
# Avoid single quotes in the awk source or you have to protect them from bash.
#

awk --file `dirname $0`/customhelps.awk --source '{
setoption("acl NET_LOCAL src", "XYZZYX")
uncomment("acl MAJOR_CVMFS")
uncomment("acl ATLAS_FRONTIER")
setoption("cache_mem", "CACHE_MEM")
setoption("maxiumum_object_size_in_memory", "1 GB")
setoption("cache_dir", "rock /var/cache/squid CACHE_DIR")
setoption("memory_cache_shared", "on")
setoption("workers", VCORE)
insertline("^# http_access deny !RESTRICT_DEST", "http_access allow ATLAS_FRONTIER")
insertline("^# http_access deny !RESTRICT_DEST", "http_access deny !MAJOR_CVMFS")
print
}'
