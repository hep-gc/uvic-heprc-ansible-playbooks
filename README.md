## HEPRC Ansible Playbooks

Repository containing to-be-public ansible playbooks to deploy software such as cloudscheduler (csv2).

Specific pre-deployment instructions are in `roles/*/README.md` for each speficic role.

To start a deployment (with playbook):

```sh
ansible-playbook --limit [hostname] -i inventory -u root staticvms.yaml
```

To start a deployment (with role):

```sh
ansible -u root -i [hostname], --ssh-extra-args='-p22' -m include_role -a name='<rolename>' [hostname]
```

Note: Don't forget the comma after the hostname in the `-i` flag if there is only a single host.

