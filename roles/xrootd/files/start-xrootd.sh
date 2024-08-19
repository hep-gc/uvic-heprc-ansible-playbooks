#!/bin/bash

BASEDIR=/var/spool/xrootd
CONFIGFILE=$BASEDIR/config/xrootd-rdc.cfg
LOGDIR=$BASEDIR/log
mkdir -p $LOGDIR

$BASEDIR/bin/end-xrootd.sh

###################################
# start a background process      #
# to monitor the local data files #
###################################
#$BASEDIR/bin/collect-rootfiles.sh &>/dev/null &
#$BASEDIR/bin/check-config.sh &>/dev/null &

ulimit -c unlimited
umask 022


ln -f -s $LOGDIR/$HOSTNAME/xrd_server-$HOSTNAME.log $BASEDIR/xrd_server-$HOSTNAME.log
ln -f -s $LOGDIR/$HOSTNAME/cmsd_server-$HOSTNAME.log $BASEDIR/cmsd_server-$HOSTNAME.log
#ln -f -s $LOGDIR/xfrd_server-$HOSTNAME.log $BASEDIR/xfrd_server-$HOSTNAME.log

xrootd  -p 1094 -I v4 -n $HOSTNAME -l $LOGDIR/xrd_server-$HOSTNAME.log -c $CONFIGFILE >& $LOGDIR/xrd_server-$HOSTNAME.log &
cmsd  -p 1095 -I v4 -n $HOSTNAME -l $LOGDIR/cmsd_server-$HOSTNAME.log -c $CONFIGFILE >& $LOGDIR/cmsd_server-$HOSTNAME.log &
#frm_xfrd -c $CONFIGFILE -l $LOGDIR/xfrd_server-$HOSTNAME.log >& $LOGDIR/xfrd_server-$HOSTNAME.log &

