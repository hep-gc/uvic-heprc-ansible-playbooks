#!/bin/bash

# Script to set csv2 test target server for continuous integration

# Check that key is where it should be
if [[ ! -f "/root/.ssh/id_rsa" ]]; then echo "Passwordless ssh key for root access to target must be present at \`/root/.ssh/id_rsa\`"; exit 1; fi

set -xe # Stop if step fails

if [ "$#" -ne 7 ]; then
    echo "Usage: ./set_ci_target.sh host_number git_branch db_upgrade_file schema_file default_pass tester_pass other_pass"
    exit 1
 fi

# $1 is host_number
host_number=${1}
target_name=elephant${host_number} # elephantxxx
host_port=22

branch=$2
db_file=$3
schema=$4

default_pass=$5
tester_pass=$6
other_pass=$7

cd /opt/deployment/uvic-heprc-ansible-playbooks/csv2

# Create inventory file
cp /opt/deployment/uvic-heprc-ansible-playbooks/csv2-ci/roles/csv2-ci/files/csv2-test-inventory.template inventory

# - Make changes based -i on input above
sed -i "s/{HOST}/${target_name}.heprc.uvic.ca/g" inventory
sed -i "s/{PORT}/$host_port/g" inventory

# Create addenda file
cp /opt/deployment/uvic-heprc-ansible-playbooks/csv2-ci/roles/csv2-ci/files/csv2-test-addenda.yaml.template addenda.yaml

# - Make changes based -i on input above
sed -i "s/{HOST}/${target_name}.heprc.uvic.ca/g" addenda.yaml
sed -i "s/{IP}/206.12.154.${host_number}/g" addenda.yaml

# Create vars and secrets

cd /opt/deployment/uvic-heprc-ansible-playbooks

# - Copy over secrets from template
cp csv2-ci/roles/csv2-ci/files/csv2-test-secrets.yaml.template csv2/roles/csv2/vars/csv2-secrets.yaml
cp csv2-ci/roles/csv2-ci/files/csv2-test-vars.yaml.template    csv2/roles/csv2/vars/csv2-vars.yaml

cd /opt/deployment/uvic-heprc-ansible-playbooks/csv2/roles/csv2/vars

# - Fill in based -i on current git branch
sed -i "s/{GITBRANCH}/$branch/g" csv2-vars.yaml
sed -i "s/{DBFILE}/$db_file/g"   csv2-vars.yaml
sed -i "s/{SCHEMA}/$schema/g"    csv2-vars.yaml
sed -i "s/{HOST}/$target_name/g" csv2-vars.yaml

sed -i "s/{DEFAULTPASS}/$default_pass/g" csv2-secrets.yaml
sed -i "s/{TESTERPASS}/$tester_pass/g"   csv2-secrets.yaml
sed -i "s/{OTHERPASS}/$other_pass/g"     csv2-secrets.yaml

# - Update unit test target
mkdir -p "/root/.csv2/unit-test"
cd "/root/.csv2/unit-test"

sed -ri "s#\s*server-address: (.*)#server-address: https://${host_number}.heprc.uvic.ca#g" settings.yaml
sed -ri "s#\s*server-password: (.*)#server-password: https://${tester_pass}#g" settings.yaml

# Copy over required files
cd /root/cloudscheduler/unit_tests/web_tests/misc_files

cp job_sample.condor job.condor
cp job_sample.sh job.sh
sed -i "s/{user}/tester/" job.condor

sudo ssh -i /root/.ssh/id_rsa -p $host_port root@${target_name}.heprc.uvic.ca "mkdir -p /home/tester"
sudo scp -i /root/.ssh/id_rsa -P $host_port job.condor "root@${target_name}.heprc.uvic.ca:/home/tester/"
sudo scp -i /root/.ssh/id_rsa -P $host_port job.sh "root@${target_name}.heprc.uvic.ca:/home/tester/"
