### Deploy HTCondor

### Requirements

- Ansible

### Recommended Configuration for the HTCondor machine

- OS: CentOS 7 or Alma 9

### Configuration Specifications

- Token and GSI authentication flags both default to False unless otherwise specified
- Configuration without GSI authentication will install the latest HTCondor version
- Configuration with GSI authentication will install HTCondor Version 8.*
- GSI authentication is not available for Alma 9 due to its incompatability with HTCondor Version 8.*

### Steps to install htcondor on a pre-configured host

- Ensure that you have root access
- Modify the vars (`htcondor-public-vars.yaml`) with correct info
- Modify the inventory file in the main uvic-heprc-ansible-playbooks/ directory with target information
- Run the htcondor playbook- see the [uvic-heprc-ansible-playbooks readme](/README.md) for further details
