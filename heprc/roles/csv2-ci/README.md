### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Recommended VM Configuration (OpenStack)

```sh
OS: CentOS 7
Flavor: s4 (recommended)
Interface: private (attach floating ip)
Security groups: default (allow TCP ingress on port 22), Jenkins (allow TCP ingress on port 8080)
SSH Key: any	
```

### Steps to install csv2 ci on a pre-configured host

- Ensure that you have an ssh key enabling root access
- Modify the vars (`csv2-ci-vars.yaml`) file in `roles/csv2-ci/vars` with correct info
- Modify the inventory file with target information

