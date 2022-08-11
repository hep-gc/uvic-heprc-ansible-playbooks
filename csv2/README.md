### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Steps to install csv2 on a pre-configured host

- Ensure that you have an ssh key enabling root access (or some other user with `sudo` privileges)
- Modify the vars (`csv2-vars.yaml`) and secrets (`csv2-secrets.yaml`) files in `roles/csv2/vars` with correct info
- Modify the inventory file (`inventory` in this folder) with target information
- Modify addenda (`addenda.yaml`)

Run:

```sh
cd csv2
ansible-playbook -i inventory -u root --check staticvms.yaml
```


