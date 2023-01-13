### Deploy XRootd Server

### Requirements

- Ansible
- Server certificates

### Steps to install
- Update /xrootd/vars.yaml and specify the directory you want to export, where those files are mounted, and the hostname of the redirector server.

- Make sure that the host certificate and the host key are already present on the system in /etc/grid-security/