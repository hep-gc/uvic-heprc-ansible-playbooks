# s3-storage-stats

## Installation

Linux:

```sh
pip3 install s3-storage-stats
```
This will install all necessary dependencies and create the executable
'/usr/local/bin/s3-storage-stats'


## Usage
Make sure the user that runs it is able to read the s3 configuration file.

```bash
s3-storage-stats -h
usage: s3-storage-stats [-h] {checksums,reports} ...

positional arguments:
  {checksums,reports}
    checksums          obtain and output object/file checksums
    reports            obtain and output storage reports

optional arguments:
  -h, --help           show this help message and exit

```

#### Sub-commands
##### Checksums
The checksums sub-command has two sub-commands itself:

###### *get*
A client gives the filename and the type of checksum hash to obtain.
If this information is found, it will be printed to stdout. If not,
'None' will be printed out.

In its simplest form it requires two positional arguments:

```bash
s3-storage-stats checksums get -f [FILE] -t [HASH_TYPE]
```

The name option specifies the name of the s3 service. It is used to
create the logfile path if not otherwise specified. The example below
will create the logfile at /var/log/xrootd/s3_proxy/s3_storage_stats.log:

```bash
s3-storage-stats checksums get -f [FILE] -t [HASH_TYPE] -n s3_proxy
```

A more complex example specifying configuration file, logging file, 
logging level and verbosity:

```bash
s3-storage-stats checksums get -f [FILE] -t [HASH_TYPE] -c /etc/xrootd/s3_config --loglevel=WARNING --logfile='/var/log/s3-storage-stats/s3_storage_stats.log' -v
```

Help:

```bash
s3-storage-stats checksums get -h
usage: s3-storage-stats checksums get [-h] [-c CONFIG_PATH] [--force] [-v]
                                         [-n S3_NAME] [--logfile LOGFILE]
                                         [--loglevel {DEBUG,INFO,WARNING,ERROR}]
                                         -t HASH_TYPE -f FILE

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG_PATH, --config CONFIG_PATH
                        Path to s3 endpoint .conf file or directory. Accepts
                        one argument. Default: '/etc/xrootd/s3cfg'.
  --force               Force command execution.
  -v, --verbose         Show on stderr events according to loglevel.
  -n S3_NAME, --name S3_NAME
                        Set the name of the s3 service. Default: ''

Logging options:
  --logfile LOGFILE     Set logfiles path. Default:
                        /var/log/xrootd/[S3_NAME]/s3_storage_stats.log
  --loglevel {DEBUG,INFO,WARNING,ERROR}
                        Set log output level. Default: WARNING.

Checksum required options:
  -t HASH_TYPE, --hash_type HASH_TYPE
                        Type of checksum hash. ['adler32', md5] Required.
  -f FILE, --file FILE  URL of object/file to request checksum of. Required.
```

---

###### *put*
A client gives the filename, checksum, and type of checksum has to add this information
to the file's metadata. Nothing is returned unless the process encounters errors.

In its simplest form it requires three positional arguments:

```bash
s3-storage-stats checksums put -f [FILE] -t [HASH_TYPE] --checksum [CHECKSUM]
```

The name option specifies the name of the s3 service. It is used to
create the logfile path if not otherwise specified. The example below
will create the logfile at /var/log/xrootd/s3_proxy/s3_storage_stats.log:

```bash
s3-storage-stats checksums put -f [FILE] -t [HASH_TYPE] --checksum [CHECKSUM] -n s3_proxy
```

A more complex example specifying configuration file path, logging file and level,
and verbosity:

```bash
s3-storage-stats checksums put -f [FILE] -t [HASH_TYPE] --checksum [CHECKSUM] -c /etc/xrootd/s3_config --loglevel=WARNING --logfile='/var/log/s3-storage-stats/s3_storage_stats.log' -v
```

Help:

```bash
s3-storage-stats checksums put -h
usage: s3-storage-stats checksums put [-h] [-c CONFIG_PATH] [--force] [-v]
                                         [-n S3_NAME] [--logfile LOGFILE]
                                         [--loglevel {DEBUG,INFO,WARNING,ERROR}]
                                         -t HASH_TYPE -f FILE --checksum
                                         CHECKSUM

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG_PATH, --config CONFIG_PATH
                        Path to s3 endpoint .conf file or directory. Accepts
                        one argument. Default: '/etc/xrootd/s3cfg'.
  --force               Force command execution.
  -v, --verbose         Show on stderr events according to loglevel.
  -n S3_NAME, --name S3_NAME
                        Set the name of the s3 service. Default: ''

Logging options:
  --logfile LOGFILE     Set logfiles path. Default:
                        /var/log/xrootd/[S3_NAME]/s3_storage_stats.log
  --loglevel {DEBUG,INFO,WARNING,ERROR}
                        Set log output level. Default: WARNING.

Checksum required options:
  -t HASH_TYPE, --hash_type HASH_TYPE
                        Type of checksum hash. ['adler32', md5] Required.
  -f FILE, --file FILE  URL of object/file to request checksum of. Required.
  --checksum CHECKSUM   String with checksum to set. Required.
```

---

#### Reports
The reports command calculates and outputs the total bytes used in the s3 storage
followed by the number of files.

In its simplest form, the reports command requires no addition arguments:

```bash
s3-storage-stats reports
```

The name option specifies the name of the s3 service. It is used to
create the logfile path if not otherwise specified. The example below
will create the logfile at /var/log/xrootd/s3_proxy/s3_storage_stats.log:

```bash
s3-storage-stats reports -n s3_proxy
```

The prefix option allows the user to specify a path prefix for the file and byte counts.
This can be used to count only the files in a specific directory:

```bash
s3-storage-stats reports --prefix='/directory_name'
```

A more complex example specifying configuration file path, logging file and level,
and verbosity:

```bash
s3-storage-stats reports -c /etc/xrootd/s3_config --loglevel=WARNING --logfile='/var/log/s3-storage-stats/s3_storage_stats.log' -v
```

Help:

```bash
s3-storage-stats reports -h
usage: s3-storage-stats reports [-h] [-c CONFIG_PATH] [--force] [-v]
                                   [-n S3_NAME] [--logfile LOGFILE]
                                   [--loglevel {DEBUG,INFO,WARNING,ERROR}]
                                   [-p PREFIX]
                                   {} ...

positional arguments:
  {}

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG_PATH, --config CONFIG_PATH
                        Path to s3 endpoint .conf file or directory. Accepts
                        one argument. Default: '/etc/xrootd/s3cfg'.
  --force               Force command execution.
  -v, --verbose         Show on stderr events according to loglevel.
  -n S3_NAME, --name S3_NAME
                        Set the name of the s3 service. Default: ''

Logging options:
  --logfile LOGFILE     Set logfiles path. Default:
                        /var/log/xrootd/[S3_NAME]/s3_storage_stats.log
  --loglevel {DEBUG,INFO,WARNING,ERROR}
                        Set log output level. Default: WARNING.

Report options:
  -p PREFIX, --prefix PREFIX
                        Prefix for directory path. Default: ''
```

## Configuration
The configuration file should be in the following format:

```bash
# Setup endpoint
host_base = [ENDPOINT_URL]
host_bucket = [ENDPOINT_URL]/[BUCKET]
region = [REGION]
use_https = boolean

# Setup access keys
access_key = [ACCESS_KEY]
secret_key = [SECRET_KEY]

# Enable S3 v4 signature API
signature_v2 = boolean

```


## References
Based on: https://pypi.org/project/dynafed-storagestats/

[Source Code] https://github.com/hep-gc/dynafed_storagestats