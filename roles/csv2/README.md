### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Recommended VM Configuration (OpenStack)

```sh
OS: CentOS 7
Flavor: s4 recommended
Interface: provider
Security groups: default, ssh_only (TCP ingress on port 22), AMQP (TCP ingress on port 15671)
SSH Key: (some key, enable root SSH)
```

### Steps to install csv2 on a pre-configured host

- Ensure that you have an ssh key enabling root access
- Modify the vars (`csv2-public-vars.yaml`) and secrets (`csv2-public-secrets.yaml`) files in `vars` with correct info
- Modify the inventory file with target information

