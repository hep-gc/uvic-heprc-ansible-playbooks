### Deploy XRootd Server

Installs, configures, and starts an XRootD server that is capable of third party copy and acting as a proxy for an S3 bucket.

### Requirements

- Ansible
- Server certificates

### Steps to install
- Place the host certificate in `/etc/grid-security/hostcert.pem`
- Place the host key in `/etc/gird-security/hostkey.pem` and make sure only the root user has read-write permissions to it.

- Edit `xrootd_vars.yaml` and set `export_path` to the base path that contains all of the data you want to share and set `localroot` to a path that you want to be automatically prefixed to every request.

- If you want a node to act as a redirector then set its hostname as the `redirector_hostname` variable, otherwise set it to some valid but unreachable hostname or leave it blank. 

- If you want a node to act as a proxy for an S3 bucket then you need to provide the credentials for the bucket in `s3_credentials_dict.yaml`; this file has a dictionary called `s3_proxy_dict` where the keys are the hostnames of the nodes you want to install as S3 proxies and the values are another dictionary with information about the bucket they are going to serve. They key-value pairs are as follows:
  - `s3_host` The hostname for the S3 server.
  - `bucket_name` The name of the bucket on the S3 server which should probably be prefixed with a `/`.
  - `access_key` The access key for the bucket.
  - `secret_key` The secret key for the bucket.

  If the hostname for one of the nodes you are configuring is found as a key in `s3_proxy_dict` then that server will be configured as an S3 proxy otherwise it will be configured as a standalone server.
  
### Authorization
Access to files in `export_path` can be further restricted and made available to only certain clients by editing the authorization database file in `templates/Authfile` based on the [XRootD documentation](https://xrootd.slac.stanford.edu/doc/dev56/sec_config.htm#_Toc119617472)

### Notes

The macaroon-secret is generated on the controller node so ansible should be either be run against all nodes in the xrootd cluster or the secret should be manually changed such that they match.
