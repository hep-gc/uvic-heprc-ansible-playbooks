from urllib.parse import urlsplit
import boto3
import datetime
from botocore.client import Config

class S3StorageShare:
    def __init__(self, storage_share):

        self.plugin_settings = storage_share['plugin_settings']

        self.plugin_settings.update(
            {
                'url': storage_share['url']
            }
        )

        _url = urlsplit(storage_share['url'])
        self.uri = {
            'hostname': _url.hostname,
            'netloc':   _url.netloc,
            'path':     _url.path,
            'port':     _url.port,
            'scheme':   _url.scheme,
            'url':      storage_share['url'],
        }

        self.debug = []
        self.status = []

        self.stats = {
            'bytesused': -1,
            'bytesfree': -1,
            'endtime': 0,
            'filecount': -1,
            'quota': 1000 ** 4,
            'starttime': int(datetime.datetime.now().timestamp()),
            'check': True,
        }

        self.validators = {
            'conn_timeout': {
                'default': 10,
                'required': False,
                'status_code': '005',
                'type': 'int',
            },
            'ssl_check': {
                'boolean': True,
                'default': True,
                'required': False,
                'status_code': '006',
                'valid': ['True', 'False', 'yes', 'no']
            },
            's3.priv_key': {
                'required': True,
                'status_code': '021',
            },
            's3.pub_key': {
                'required': True,
                'status_code': '022',
            },
            's3.region': {
                'default': 'us-east-1',
                'required': False,
                'status_code': '023',
            },
            's3.signature_ver': {
                'default': 's3v4',
                'required': False,
                'status_code': '024',
                'valid': ['s3', 's3v4'],
            },
        }

        self.validate_plugin_settings()

        self.uri['bucket'] = self.uri['path'].rpartition("/")[-1]
        self.star_fields = {
            'storage_share': self.uri['bucket'],
        }


    def validate_plugin_settings(self):
        """ 
        checks for required plugin settings
        """
        
        for _setting in self.validators:
            try:
                self.plugin_settings[_setting]

            except KeyError:
                try:
                    if self.validators[_setting]['required']:
                        raise Exception
                    else:
                        # print(f"warning: missing setting {_setting}, using default value {self.validators[_setting]['default']}")
                        self.plugin_settings.update({_setting: self.validators[_setting]['default']})
                except Exception:
                    self.stats['check'] = "MissingRequiredSetting"
                    print("an error occurred")


    def get_object_checksum(self, hash_type, object_url):
        """
        return the metadata of the specified hash type.
        returns None if the metadata does not exist
        """
        _metadata = self.get_object_metadata(object_url)
        
        try:
            return _metadata[hash_type]
        except KeyError:
            return None


    def get_object_metadata(self, object_url):
        """
        get and return the metadata from the file
        in s3 storage
        """

        _connection = self.get_s3_boto_client()
        _kwargs = {
            "Bucket": self.uri["bucket"],
            "Key": object_url,
        }
        
        _result = run_boto_client(_connection, 'head_object', _kwargs)
        _metadata = {k.lower(): v for k, v in _result['Metadata'].items()}
        
        return _metadata


    def put_object_checksum(self, checksum, hash_type, object_url, force):
        """
        check if there is existing metadata in the s3 file metadata
        if metadata exists, exit unless force is true
        """
        _metadata = self.get_object_metadata(object_url)

        if hash_type not in _metadata:
            # no metadata exists of this hash type, add metadata
            _metadata.setdefault(hash_type, checksum)
            self.put_object_metadata(_metadata, object_url)

        elif force:
            # metadata already exists, replace metadata
            _metadata[hash_type] = checksum
            self.put_object_metadata(_metadata, object_url)

        else:
            # metadata already exists
            print("no new metadata")
            exit(0)


    def put_object_metadata(self, metadata, object_url):
        """
        put the new data in the metadata of the
        specified file in s3 storage
        """
        _connection = self.get_s3_boto_client()

        _kwargs = {
            'Bucket': self.uri['bucket'],
            'CopySource': {
                'Bucket': self.uri['bucket'],
                'Key': object_url,
            },
            'Key': object_url,
            'Metadata': metadata,
            'MetadataDirective': 'REPLACE',
        }

        try:
            # ensure there is new metadata to enter
            assert len(metadata) != 0
            run_boto_client(_connection, 'copy_object', _kwargs)
        
        except Exception as e:
            print("an error occurred: ", e)
            exit(1)


    def get_s3_boto_client(self):
        """
        create and return a connection to s3 storage
        """
        _api_url = f"{self.uri['scheme']}://{self.uri['netloc']}"
        _session = boto3.session.Session()

        _connection = _session.client(
            "s3",
            region_name=self.plugin_settings['s3.region'],
            endpoint_url=_api_url,
            aws_access_key_id=self.plugin_settings['s3.pub_key'],
            aws_secret_access_key=self.plugin_settings['s3.priv_key'],
            use_ssl=True,
            verify=self.plugin_settings['ssl_check'],
            config = Config(
                signature_version=self.plugin_settings['s3.signature_ver'],
                connect_timeout=int(self.plugin_settings['conn_timeout']),
                retries=dict(max_attempts=0)
            )
        )
        
        return _connection


    def list_objects(self):
        """
        get the files in s3 storage, calculate, and 
        return the number of files and bytes used
        """
        _connection = self.get_s3_boto_client()
        
        _total_bytes = 0
        _total_files = 0
        
        _kwargs = {
            'Bucket': self.uri['bucket'],
            'Prefix': '',
            # 'Delimiter': '/',
        }
        
        while True:
            _response = run_boto_client(_connection, 'list_objects', _kwargs)
            
            # check for files in the response
            try:
                _response['Contents']
            except KeyError:
                self.stats['bytesused'] = 0
                break
            else:
                for _file in _response['Contents']:
                    _total_bytes += int(_file['Size'])
                    _total_files += 1
            
            # marker indicating the location of the last file read        
            try:
                _kwargs['Marker'] = _response['NextMarker']
            except KeyError:
                break
                
        return int(_total_bytes), _total_files


def run_boto_client(_connection, method, _kwargs):
    """
    runs the specified function with the 
    given arguments and returns the result
    """
    _function = getattr(_connection, method)
    _result = _function(**_kwargs)
    return _result
