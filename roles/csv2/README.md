### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Recommended Configuration for the Cloudscheduler machine


- OS: Almalinux 9
- Minimal machine  Requirements: 4+ cores, 8GB+ RAM, 100GB+ disk
  - more needed when using the HTCondor on the cloudscheduler machine instead of an external one
- Other requirements: 
  - machine needs to have hostname based on DNS for its IPv4
  - machine will need to have selinux disabled
- Open ports needed (these will be configured for the machine if use_firewalld is set to true): 
  - 80(http) 
  - 443(https) 
  - 15671(AMQP for external condor machines only; managed by csv2) 
  - 3306 (mysql for external condor machines only; managed by csv2) 
  - 9618 and 40000-50000 (when HTCondor on the csv2 machine is used) 
  - 8086 (influxdb for timeseries)

### Steps to install csv2 on a pre-configured host

- Ensure that you have root access
- Modify the vars (`csv2-public-vars.yaml`) and secrets (`csv2-public-secrets.yaml`) files in `vars/` with correct info
- Modify the inventory file in the main uvic-heprc-ansible-playbooks/ directory with target information
- Run the csv2 playbook- see the [uvic-heprc-ansible-playbooks readme](/README.md) for further details
