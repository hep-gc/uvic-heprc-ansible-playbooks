### HEPRC Project Software

Specific pre-deployment instructions are in `roles/*/README.md` for each speficic role.

To start a deployment:

```sh
ansible-playbook --limit [hostname] -i inventory -u root staticvms.yaml
```

