#!/bin/bash
#this script assumes sudo/root

#create condor_poller directory structure
STAGE_DIRS=("/tmp/gentgz/cloudscheduler/data_collectors/condor"
            "/tmp/gentgz/cloudscheduler/etc/cloudscheduler"
            "/tmp/gentgz/cloudscheduler/etc/init.d"
            "/tmp/gentgz/cloudscheduler/etc/systemd/system"
            "/tmp/gentgz/cloudscheduler/lib"
            "/tmp/gentgz/cloudscheduler/utilities")

for dir in "${STAGE_DIRS[@]}"; do
    mkdir -p -v "$dir" -m 0755
    chown root:root "$dir"
done

#create symlink for cloudscheduler in tmp
rel_path=$(realpath --relative-to="/tmp/gentgz/cloudscheduler/data_collectors/condor" "/tmp/gentgz/cloudscheduler")
ln -s -f -n "$rel_path" "/tmp/gentgz/cloudscheduler/data_collectors/condor/cloudscheduler"

#copy condor_poller files
SRC="/opt/cloudscheduler/"
DEST="/tmp/gentgz/cloudscheduler/"

declare -A FILE_MODE=(
  ["data_collectors/condor/condor_poller.py"]="0644"
  ["etc/init.d/csv2-condor-poller.pfile"]="0644"
  ["etc/systemd/system/csv2-condor-poller.service.pfile"]="0644"
  ["lib/attribute_mapper.py"]="0644"
  ["lib/db_config.py"]="0644"
  ["lib/fw_config.py"]="0644"
  ["lib/poller_functions.py"]="0644"
  ["lib/ProcessMonitor.py"]="0644"
  ["lib/log_tools.py"]="0644"
  ["lib/schema.py"]="0644"
  ["lib/watchdog_utils.py"]="0644"
  ["utilities/service_disable_condor_poller"]="0744"
  ["utilities/service_enable_condor_poller"]="0744"
)

for file in "${!FILE_MODE[@]}"; do
  src="$SRC$file"
  dest="$DEST$file"
  mode="${FILE_MODE[$file]}"

  install -D -m "$mode" "$src" "$dest"
done

#copy config file
src="/opt/cloudscheduler/etc/cloudscheduler/condor_poller.yaml"
dest="/tmp/gentgz/cloudscheduler/etc/cloudscheduler/condor_poller.yaml"

install -m 0400 "$src" "$dest"

#remove certs
file="/tmp/gentgz/cloudscheduler/etc/cloudscheduler/condor_poller.yaml"
sed -i 's/^condor_worker_cert:.*/    condor_worker_cert:/' "$file"
sed -i 's/^condor_worker_key:.*/    condor_worker_key:/' "$file"

#build tarball
src_dir="/tmp/gentgz/cloudscheduler"
tmp_dir="/tmp/gentgz"

cd "$tmp_dir"
tar -czvf /opt/cloudscheduler/repository/condor_poller.tar.gz cloudscheduler

#remove dir
rm -rf "$tmp_dir"
