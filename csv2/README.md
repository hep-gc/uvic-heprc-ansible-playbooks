### Deploy cloudscheduler (csv2)

### Requirements

- Ansible

### Steps to install csv2 on a pre-configured host

- Ensure that you have an ssh key enabling root access (or some other user with `sudo` privileges)
- Modify the vars and secrets files in `roles/csv2/vars` with correct info (and you have the required vault password file)
- Modify the inventory file (in this folder) with target information

Run:

```sh
ansible-playbook -i /root/deploy/inventory -u root --vault-password-file /root/.pw/staticvms --check staticvms.yaml
```


