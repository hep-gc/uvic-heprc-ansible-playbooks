from urllib.parse import urlsplit
import boto3
import datetime
from botocore.client import Config

class S3StorageShare:
    def __init__(self, storage_share):

        # self.id = storage_share['id']
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

        #self.plugin = storage_share['plugin']

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
            'storagestats.api': {
                'default': 'generic',
                'required': False,
                'status_code': '070',
                'valid': ['generic'],
            },
            'storagestats.frequency': {
                'default': '600',
                'required': False,
                'status_code': '072'
            },
            'storagestats.quota': {
                'default': 'api',
                'required': False,
                'status_code': '071',
            },
            'ssl_check': {
                'boolean': True,
                'default': True,
                'required': False,
                'status_code': '006',
                'valid': ['true', 'false', 'yes', 'no']
            },
            's3.alternate': {
                'default': 'false',
                'required': False,
                'status_code': '020',
                'valid': ['true', 'false', 'yes', 'no']
            },
            'storagestats.api': {
                'default': 'generic',
                'required': False,
                'status_code': '070',
                'valid': ['ceph-admin', 'cloudwatch', 'generic', 'list-objects',
                            'minio_prometheus', 'minio_prometheus_v2'],
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
        for _setting in self.validators:
            try:
                self.plugin_settings[_setting]

            except KeyError:
                try:
                    if self.validators[_setting]['required']:
                        raise Exception
                    else:
                        print("warning: missing setting")
                        self.plugin_settings.update({_setting: self.validators[_setting]['default']})
                except Exception:
                    self.stats['check'] = "MissingRequiredSetting"
                    print("an error occurred")

            
    def get_object_checksum(self, hash_type, object_url):
        _metadata = self.get_object_metadata(object_url)
        
        try:
            return _metadata[hash_type]
        except KeyError:
            return {}
        
    def get_object_metadata(self, object_url):
        _object_path = urlsplit(object_url).path

        _object_key = _object_path.split('/')[1::]
        if self.uri["bucket"] in _object_key:
            _object_key.remove(self.uri["bucket"])

        _object_key = '/'.join(_object_key)

        _connection = self.get_s3_boto_client()
        _kwargs = {
            "Bucket": self.uri["bucket"],
            "Key": _object_key,

        }
        
        return run_boto_client(_connection, 'head_object', _kwargs)


    def put_object_checksum(self, checksum, hash_type, object_url, force):
        _metadata = self.get_object_metadata(object_url)

        if hash_type not in _metadata:
            _metadata.setdefault(hash_type, checksum)
            self.put_object_metadata(_metadata, object_url)

        elif force:
            _metadata[hash_type] = checksum
            self.put_object_metadata(_metadata, object_url)

        else:
            print("no new metadata")


    def put_object_metadata(self, metadata, object_url):
        
        _object_path = urlsplit(object_url).path

        _object_key = _object_path.split('/')[1::]
        if self.uri['bucket'] in _object_key:
            _object_key.remove(self.uri['bucket'])
        _object_key = '/'.join(_object_key)

        _connection = self.get_s3_boto_client()

        _kwargs = {
            'Bucket': self.uri['bucket'],
            'CopySource': {
                'Bucket': self.uri['bucket'],
                'Key': _object_key,
            },
            'Key': _object_key,
            'Metadata': metadata,
            'MetadataDirective': 'REPLACE',
        }

        try:
            assert len(metadata) != 0
            _result = run_boto_client(_connection, 'copy_object', _kwargs)

        except Exception as e:
            print("an error occurred: ", e)
            exit(1)


    def get_s3_boto_client(self):
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


def run_boto_client(_connection, method, _kwargs):
    _function = getattr(_connection, method)
    _result = _function(**_kwargs)

    _metadata = {k.lower(): v for k, v in _result['Metadata'].items()}
    return _metadata
