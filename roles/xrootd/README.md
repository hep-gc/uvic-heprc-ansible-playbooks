### Deploy XRootd Server

### Requirements

- Ansible
- Server certificates

### Steps to install
- Update /xrootd/vars/xrootd_vars.yaml and specify a directory to store xrootd files, a directory to store the data you want to serve, and the hostname of the redirector server.
- Modify the inventory file and supply the following host variables 'hostcert' 'hostkey' and 'ansible_user'

Example
```
[xrootd]
elephant102.heprc.uvic.ca hostcert=102_cert.pem hostkey=102_key.pem ansible_user=centos
```
