### Deploy XRootd Server

### Requirements

- Ansible
- Server certificates

### Steps to install
- Update /xrootd/vars/xrootd_vars.yaml and specify a directory to store xrootd files, a directory to store the data you want to serve, and the hostname of the redirector server.

- Rename the host keys and certificates to XXX_cert.pem and XXX_key.pem where XXX is the hostname in the inventory and place all of them in the credentials directory.