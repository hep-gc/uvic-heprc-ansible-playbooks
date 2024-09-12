#!/bin/bash

# Script to set csv2 test target server for continuous integration

# Check that key is where it should be
if [[ ! -f "/root/.ssh/id_rsa" ]]; then echo "Passwordless ssh key for root access to target must be present at \`/root/.ssh/id_rsa\`"; exit 1; fi

set -xe # Stop if step fails

if [ "$#" -ne 9 ]; then
    echo "Usage: ./set_ci_target.sh host_machine git_branch db_upgrade_file schema_file default_pass tester_pass other_pass influx_pass influx_admin_pass"
    exit 1
 fi


# $1 is host_number
host_machine=${1}
target_name=$(echo $host_machine|cut -d. -f1)
host_port=22

branch=$2
db_file=$3
schema=$4

default_pass=$5
tester_pass=$6
other_pass=$7
influx_pass=$8
influx_admin_pass=$9

cd /opt/deployment/uvic-heprc-ansible-playbooks

# Create inventory file
cp /opt/deployment/uvic-heprc-ansible-playbooks/roles/csv2-ci/files/csv2-test-inventory.template inventory

# - Make changes based -i on input above
sed -i "s/{HOST}/${host_machine}/g" inventory
sed -i "s/{PORT}/$host_port/g" inventory

# Create vars and secrets

cd /opt/deployment/uvic-heprc-ansible-playbooks

# - Copy over secrets from template
cp roles/csv2-ci/files/csv2-test-secrets.yaml.template roles/csv2/vars/csv2-public-secrets.yaml
cp roles/csv2-ci/files/csv2-test-vars.yaml.template    roles/csv2/vars/csv2-public-vars.yaml

cd /opt/deployment/uvic-heprc-ansible-playbooks/roles/csv2/vars

# - Fill in based -i on current git branch
sed -i "s/{GITBRANCH}/$branch/g"            csv2-public-vars.yaml
sed -i "s/{DBFILE}/$db_file/g"              csv2-public-vars.yaml
sed -i "s/{SCHEMA}/$schema/g"               csv2-public-vars.yaml
sed -i "s/{HOST}/${host_machine}/g"            csv2-public-vars.yaml
sed -i "s/{IP}/$(curl ifconfig.me)/g" csv2-public-vars.yaml

sed -i "s/{DEFAULTPASS}/$default_pass/g" csv2-public-secrets.yaml
sed -i "s/{TESTERPASS}/$tester_pass/g"   csv2-public-secrets.yaml
sed -i "s/{OTHERPASS}/$other_pass/g"     csv2-public-secrets.yaml
sed -i "s/{INFLUXPASS}/$influx_pass/g"   csv2-public-secrets.yaml
sed -i "s/{INFLUXADMINPASS}/$influx_admin_pass/g"   csv2-public-secrets.yaml

# - Update unit test target
mkdir -p "/root/.csv2/unit-test"
cd "/root/.csv2/unit-test"

sed -ri "s#\s*server-address: (.*)#server-address: https://${host_machine}#g" settings.yaml
sed -ri "s#\s*server-password: (.*)#server-password: ${tester_pass}#g" settings.yaml

# Copy over required files
cd /root/cloudscheduler/unit_tests/web_tests/misc_files

cp job_sample.condor job.condor
cp job_sample.sh job.sh
sed -i "s/{user}/tester/" job.condor

sudo ssh -i /root/.ssh/id_rsa -p $host_port root@${host_machine} "mkdir -p /home/tester"
sudo scp -i /root/.ssh/id_rsa -P $host_port job.condor "root@${host_machine}:/home/tester/"
sudo scp -i /root/.ssh/id_rsa -P $host_port job.sh "root@${host_machine}:/home/tester/"
