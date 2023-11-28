import argparse

def parse_args(args):
    parser = argparse.ArgumentParser()
    subparser = parser.add_subparsers()
    
    add_checksums_subparser(subparser)
    add_reports_subparser(subparser)
    
    return parser.parse_args(args)


def add_checksums_subparser(subparser):
    parser = subparser.add_parser(
        'checksums',
        help="obtain and output object/file checksums"
    )
    subparser = parser.add_subparsers()
    parser.set_defaults(cmd='checksums')
    
    add_checksums_get_subparser(subparser)
    add_checksums_put_subparser(subparser)

    
def add_checksums_get_subparser(subparser):
    parser = subparser.add_parser(
        'get', 
        help="Get object/file checksums"
    )
    parser.set_defaults(sub_cmd='get')

    add_checksum_options(parser)

    
def add_checksums_put_subparser(subparser):
    parser = subparser.add_parser(
        'put',
        help="Set object/file checksums.."
    )

    parser.set_defaults(sub_cmd='put')
    
    group_checksum = add_checksum_options(parser)

    group_checksum.add_argument(
        '--checksum',
        action='store',
        default=False,
        dest='checksum',
        type=str.lower,
        help="String with checksum to set. ['adler32', md5] "
            "Required"
    )


def add_reports_subparser(subparser):
    parser = subparser.add_parser(
        'reports',
        help="obtain and output storage reports"
    )
    subparser = parser.add_subparsers()
    parser.set_defaults(cmd='reports')
    
    add_reports_storage_subparser(subparser)
    
def add_reports_storage_subparser(subparser):
    parser = subparser.add_parser(
        'storage', 
        help="Generate storage related report."
    )
    parser.set_defaults(sub_cmd='storage')

    add_general_options(parser)

    
def add_checksum_options(parser):
    
    add_general_options(parser)
    
    group_checksum = parser.add_argument_group("Checksum required options")

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
        '-f', '--file',
        action='store',
        default=False,
        required=True,
        dest='file',
        help="URL of object/file to request checksum of. "
                "Required."
    )
    
    return group_checksum

    
def add_general_options(parser):
    parser.add_argument(
        '-c', '--config',
        action='store',
        default='/etc/xrootd/s3cfg',
        dest='config_path',
        type=str.lower,
        help="Path to s3 endpoint .conf file or directory. "
            "Accepts one argument. "
            "Default: '/etc/xrootd/s3cfg'."
    )
    
    parser.add_argument(
        '--force',
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