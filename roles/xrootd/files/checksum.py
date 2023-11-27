import boto3
import sys
import os
from urllib.parse import urlsplit
import argparse
from base import S3StorageShare
import glob

def main():
    # fetch the checksum from s3

    # store the checksum in s3 metadata

    args = sys.argv[1:]
    ARGS = parse_args(args)

    checksums(ARGS)

def checksums(ARGS):
    # TODO: check for required args
    _storage_shares = parse_conf_files(
        ARGS.config_path,
        ARGS.endpoint
    )
    _storage_shares = get_storage_share_objects(_storage_shares)

    for _storage_share in _storage_shares:
        
        if ARGS.sub_cmd == 'get':
            _checksum = _storage_share.get_object_checksum(
                ARGS.hash_type,
                ARGS.url
            )
            
        elif ARGS.sub_cmd == 'put':
            _storage_share.put_object_checksum(
                ARGS.checksum,
                ARGS.hash_type,
                ARGS.url,
                force=ARGS.force
            )
        
        print(_checksum)



def get_storage_share_objects(storage_shares):

    _storage_share_objects = []

    for _storage_share in storage_shares:
        _storage_share_objects.append(S3StorageShare(storage_shares[_storage_share]))

    return _storage_share_objects




def parse_conf_files(config_path, storage_shares_mask=[]):

    _storage_shares = {}
    _global_settings = {}
    _config_files = get_conf_files(config_path)

    _keys = {
        "access_key": "s3.pub_key",
        "secret_key": "s3.priv_key",
        "region": "s3.region",
        "ssl_check": "s3.ssl_check"
    }

    for _config_file in _config_files:
        try:
            with open(_config_file, "r") as _file:
                for _line_number, _line in enumerate(_file):
                    _line = _line.strip()

                    if not _line.startswith("#"):

                        _key, _value = _line.partition("=")[::2]

                        _key = _key.strip()
                        if _key in _keys:
                            _id = "s3"
                            _setting = _keys[_key]
                            _storage_shares.setdefault(_id, {})
                            _storage_shares[_id].setdefault('plugin_settings', {})
                            _storage_shares[_id]['plugin_settings'].update({_setting: _value.strip()})

                        elif _key == "host_bucket":
                            _id = "s3"
                            _storage_shares.setdefault(_id, {})
                            _storage_shares[_id].update({'id': _id.strip()})
                            _storage_shares[_id].update({'url': _value.strip()})


        except Exception as e:
            print("exception occurred: ", e)
            continue
    return _storage_shares


def get_conf_files(config_path):

    _config_files = []

    for _element in config_path:
        if os.path.isdir(_element):
            _config_files = _config_files + sorted(glob.glob(_element + "/" + "*.conf"))

        elif os.path.isfile(_element):
            _config_files.append(_element)

        else:
            print("error occurred")

    if not _config_files:
        raise Exception("No config files were found")

    return _config_files


def parse_args(args):
    parser = argparse.ArgumentParser()
    subparser = parser.add_subparsers()
    
    parser = subparser.add_parser(
        'checksums',
        help="obtain and output object/file checksums"
    )
    subparser = parser.add_subparsers()
    parser.set_defaults(cmd='checksums')
    
    add_checksums_get_subparser(subparser)
    add_checksums_put_subparser(subparser)
    
    
    return parser.parse_args(args)

def add_checksums_get_subparser(subparser):
    parser = subparser.add_parser(
        'get', 
        help="Get object/file checksums"
    )
    parser.set_defaults(sub_cmd='get')

    add_common_options(parser)
    

    
def add_checksums_put_subparser(subparser):
    parser = subparser.add_parser(
        'put',
        help="Set object/file checksums.."
    )

    parser.set_defaults(sub_cmd='put')
    
    group_checksum = add_common_options(parser)

    group_checksum.add_argument(
        '--checksum',
        action='store',
        default=False,
        dest='checksum',
        type=str.lower,
        help="String with checksum to set. ['adler32', md5] "
            "Required"
    )
    

def add_common_options(parser):
    """Add general optional arguments used by any subcommand.

    Arguments:
    parser -- Object form argparse.ArgumentParser()

    """
    parser.add_argument(
        '-c', '--config',
        action='store',
        default=['/etc/xrootd/s3cfg'],
        dest='config_path',
        nargs='*',
        help="Path to UGRs endpoint .conf files or directories. "
            "Accepts any number of arguments. "
            "Default: '/etc/ugr/conf.d'."
    )
    parser.add_argument(
        '-f', '--force',
        action='store_true',
        default=False,
        dest='force',
        help="Force command execution."
    )
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        default=False,
        dest='verbose',
        help="Show on stderr events according to loglevel."
    )
    
    group_checksum = parser.add_argument_group("Checksum required options")

    group_checksum.add_argument(
        '-e', '--endpoint',
        action='store',
        default=False,
        dest='endpoint',
        required=True,
        type=str.lower,
        help="Type of checksum hash. ['adler32', md5] "
                "Required."
    )

    group_checksum.add_argument(
        '-t', '--hash_type',
        action='store',
        default=False,
        dest='hash_type',
        required=True,
        type=str.lower,
        help="Type of checksum hash. ['adler32', md5] "
                "Required."
    )

    group_checksum.add_argument(
        '-u', '--url',
        action='store',
        default=False,
        required=True,
        dest='url',
        help="URL of object/file to request checksum of. "
                "Required."
    )
    
    return group_checksum


if __name__ == '__main__':
    main()