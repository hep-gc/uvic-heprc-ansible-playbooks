### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Recommended VM Configuration

```sh
OS: CentOS 7
Flavor: s4 recommended
Interface: provider
Security groups: default, ssh_only (TCP ingress on port 22), AMQP (TCP ingress on port 15671)
SSH Key: (some key, enable root SSH)
```

### Steps to install csv2 on a pre-configured host

- Ensure that you have an ssh key enabling root access (or some other user with `sudo` privileges)
- Modify the vars (`csv2-vars.yaml`) and secrets (`csv2-secrets.yaml`) files in `roles/csv2/vars` with correct info
- Modify the inventory file (`inventory` in this folder) with target information
- Modify addenda (`addenda.yaml`)

Run:

```sh
ansible-playbook -i inventory -u root --check staticvms.yaml
```


