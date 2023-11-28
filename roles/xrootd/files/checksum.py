import sys
from base import S3StorageShare
from args import parse_args

def main():
    args = sys.argv[1:]
    ARGS = parse_args(args)

    if ARGS.cmd == 'checksums':
        checksums(ARGS)
    elif ARGS.cmd == 'reports':
        reports(ARGS)
        

def checksums(ARGS):
    # TODO: check for required args
    _storage_share = parse_conf_file(ARGS.config_path)
    _storage_share = S3StorageShare(_storage_share)
    
    if ARGS.sub_cmd == 'get':
        _checksum = _storage_share.get_object_checksum(
            ARGS.hash_type,
            ARGS.file
        )
        print(_checksum)

    elif ARGS.sub_cmd == 'put':
        _storage_share.put_object_checksum(
            ARGS.checksum,
            ARGS.hash_type,
            ARGS.file,
            force=ARGS.force
        )

def reports(ARGS):
    #TODO: check for required args
    
    _storage_share = parse_conf_file(ARGS.config_path)
    _storage_share = S3StorageShare(_storage_share)
    
    _total_bytes, _total_files = _storage_share.list_objects()
    print(_total_bytes, _total_files)

def parse_conf_file(config_path):
    _storage_share = {}

    _keys = {
        "access_key": "s3.pub_key",
        "secret_key": "s3.priv_key",
        "region": "s3.region",
        "use_https": "ssl_check",
        "signature_v2": "s3.signature_ver",
    }

    try:
        with open(config_path, "r") as _file:
            for _line in _file:
                _line = _line.strip()
                
                if not _line.startswith("#"):
                    _key, _value = _line.partition("=")[::2]
                    _key = _key.strip()
                    
                    if _key in _keys:
                        _setting = _keys[_key]
                        _value = _value.strip()
                        _storage_share.setdefault('plugin_settings', {})
                        
                        if _key == "use_https":
                            _value = _value.lower() == "true"
                        
                        elif _key == "signature_v2":
                            _value = "s3v4" if _value.lower() == "true" else "s3"
                        
                        _storage_share['plugin_settings'][_setting] = _value

                    elif _key == "host_bucket":
                        _storage_share['url'] = _value.strip()
                        
                            
    except Exception as e:
        print("exception occurred: ", e)
        
    return _storage_share


if __name__ == '__main__':
    main()