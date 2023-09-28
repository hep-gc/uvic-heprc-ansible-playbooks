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
setoption("acl NET_LOCAL src", "IP")
uncomment("acl MAJOR_CVMFS")
uncomment("acl ATLAS_FRONTIER")
setoption("cache_mem", "CACHE_MEM")
setoption("cache_dir", 3, "CACHE_DIR")
setoption("workers", VCORE)
setoptionparameter("cache_dir", 2, "/var/cache/squid/squid${process_number}")
setoption("cpu_affinity_map", "process_numbers=1,2,3,4,5,6,7 cores=1,2,3,4,5,6,7")
insertline("^acl MAJOR_CVMFS", "acl BELLEII dstdom_regex ^(cvmfs-stratum-one.cc.kek.jp)$ ")
insertline("^# http_access deny !RESTRICT_DEST", "http_access allow BELLEII")
insertline("^# http_access deny !RESTRICT_DEST", "http_access allow ATLAS_FRONTIER")
insertline("^# http_access deny !RESTRICT_DEST", "http_access deny !MAJOR_CVMFS")
print
}'
