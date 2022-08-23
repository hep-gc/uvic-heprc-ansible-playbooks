## HEPRC Ansible Playbooks

Repository containing to-be-public ansible playbooks to deploy software such as cloudscheduler (csv2).

Specific pre-deployment instructions are in `roles/*/README.md` for each speficic role.

### To start a deployment (with playbook):

Insert into `inventory` file `[hostname]:[port]` in a new line under the correct role tag.

Run:

```sh
ansible-playbook --limit [hostname] -i inventory -u root main.yaml
```
