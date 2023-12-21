
import logging
import logging.handlers
import os

def setup_logger(logfile, loglevel, xrootd_name, verbose):
    """Setup the logger format to be used throughout the script.

    Arguments:
    logfile -- string defining path to write logs to.
    loglevel -- string defining level to log: "DEBUG, INFO, WARNING, ERROR"
    verbose -- boolean. 'True' prints log messages to stderr.

    """
    # To capture warnings emitted by modules.
    logging.captureWarnings(True)

    # Create file logger.
    _logger = logging.getLogger("storage_stats")

    # Set log level to use.
    _num_loglevel = getattr(logging, loglevel.upper())
    _logger.setLevel(_num_loglevel)

    # create default value for logfile if not specified
    logfile = logfile or os.path.join("/var/log/xrootd/", xrootd_name, "s3_storage_stats.log")        

    # Set file where to log and the mode to use and set the format to use.
    _log_handler_file = logging.handlers.TimedRotatingFileHandler(
        logfile,
        when="midnight",
        backupCount=15,
    )

    # Set logger format
    _log_format_file = logging.Formatter('%(asctime)s - [%(levelname)s] %(message)s')

    # Set the format to the file handler.
    _log_handler_file.setFormatter(_log_format_file)

    # Add the file handler.
    _logger.addHandler(_log_handler_file)

    # Create STDERR handler if verbose is requested and add it to logger.
    if verbose:
        log_handler_stderr = logging.StreamHandler()
        log_format_stderr = logging.Formatter('%(asctime)s - [%(levelname)s] %(message)s')

        log_handler_stderr.setLevel(_num_loglevel)
        log_handler_stderr.setFormatter(log_format_stderr)
        # Add handler
        _logger.addHandler(log_handler_stderr)
