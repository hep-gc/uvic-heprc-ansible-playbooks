### Deploy frontier-varnish

### Requirements

- Ansible

### Recommended Configuration for the frontier-varnish machine

- OS: Almalinux 9
- Machine Requirements
  - Frontier: 1 core, 8GB RAM
  - CVMFS: 2 cores, 64GB RAM
- Other requirements: 
  - machine needs to have hostname based on DNS for its IPv4
  - machine will need to have selinux disabled

### Configuration Specifications

- `upstream` variable must be set to either 'cvmfs' or 'frontier'
- `varnish_site` and `varnish_instance` must be set to valid keys that map to configuration file 

### Steps to install frontier-varnish on a pre-configured host

- Ensure that you have root access
- Modify the vars (`varnish-public-vars.yaml`) in `vars/` with correct info
- Modify the inventory file in the main uvic-heprc-ansible-playbooks/ directory with target information
- Run the csv2 playbook- see the [uvic-heprc-ansible-playbooks readme](/README.md) for further details
