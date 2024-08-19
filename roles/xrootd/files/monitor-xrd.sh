#!/bin/bash

METRIC_TTL=905
while read line
do
 linearray=($line)
 name=""
 unit=""
 if [ "${linearray[0]}" != "" ];
 then
  case ${linearray[0]} in 
	link.num)
           name="number of connections"
	   unit="Connections"
           ;;
	link.maxn)
	   unit="Connections"
	   name="max number of connections"
 	   ;;
	link.tot)
	   unit="Connections"
	   name="connections since start"
	  ;;
	link.in)
	   unit="Bytes"
	   name="Bytes received"
	   ;;
	link.out)
	   unit="Bytes"
	   name="Bytes sent"
   	   ;;
	#link.ctime)
	#   name="total time for connections
        #   ;;
	link.tmo)
 	   unit="Number of requests"
	    name="Read request timeouts"
 	    ;;
	link.stall)
	   unit="Count"
	    name="Partial data received"
	    ;;
	link.sfps)
	   unit="Count"
	    name="number of times partial data sent"
	    ;;
	xrootd.num)
	   unit="Count"
	    name="number of times xrootd selected"
	    ;;
	xrootd.ops.open)
	   unit="Count"
	    name="File open requests"
 	    ;;
	xrootd.ops.rf)
	   unit="Count"
	    name="Cache refresh requests"
	    ;;
	xrootd.ops.rd)
	   unit="Count"
	    name="Read requests"
	    ;;
	xrootd.ops.pr)
	   unit="Count"
	    name="Pre-read requests"
	    ;;
	xrootd.ops.rv)
	    name="Readv requests"
	   unit="Count"
	    ;;
	xrootd.ops.rs)
	   unit="Count"
	    name="Readv segments"
	    ;;
	xrootd.ops.wr)
	   unit="Count"
	    name="Write requests"
 	    ;;
	xrootd.ops.sync)
	   unit="Count"
	    name="Sync requests"
	    ;;
	xrootd.ops.getf)
	   unit="Count"
	    name="Get file requests"
	    ;;
	xrootd.ops.putf)
	   unit="Count"
	    name="Put file requests";;
	#xrootd.sig.ok)
	#xrootd.sig.bad)
	#xrootd.sig.ign)
	xrootd.aio.num)
	   unit="Count"
	    name="Async requests"
	    ;;
	xrootd.aio.max)
	   unit="Count"
	    name="max parallel async requests"
	    ;;
	xrootd.aio.rej)
	   unit="Count"
	    name="async requests changed to sync"
	    ;;
	xrootd.err)
	   unit="Count"
	    name="number of requests with error";;
	xrootd.rdr)
	    unit="Count"
	    name="redirected requests";;
	xrootd.dly)
	    unit="Count"
	    name="delayed requests";;
	xrootd.lgn.num)
	    unit="Count"
	    name="login attempts";;
	xrootd.lgn.af)
	    unit="Count"
	    name="authentication failures";;
	xrootd.lgn.au)
	    unit="Count"
	    name="successful authenticated logins";;
	xrootd.lgn.ua)
	    unit="Count"
	    name="unauthenticated logins";;
	ofs.opr)
	    unit="Count"
	    name="files opened for read";;
	ofs.opw)
	    unit="Count"
	    name="files opened for write";;
	#ofs.opp)
	#ofs.ups)
	ofs.han)
	    unit="Count"
	    name="active file handles";;
	ofs.rdr)
	    unit="Count"
	    name="redirects processed";;
	ofs.bxq)
	    unit="Count"
	    name="background tasks processed";;
	ofs.rep)
	    unit="Count"
	    name="background replies processed";;
	ofs.err)
	    unit="Count"
	    name="OFS errors";;
	ofs.dly)
	    unit="Count"
	    name="OFS delays";;
	ofs.sok)
	    unit="Count"
	    name="OFS success events";;
	ofs.ser)
	    unit="Count"
	    name="OFS error events";;
	ofs.tpc.grnt)
	    unit="Count"
	    name="TPC events allowed";;
	ofs.tpc.deny)
	    unit="Count"
	    name="TPC events denied";;
	ofs.tpc.err)
	    unit="Count"
	    name="TPC errors";;
	ofs.tpc.exp)
	    unit="Count"
	    name="TPC auth expired";;
	oss.paths)
	    unit="Count"
	    name="subsequent path stats";;
	#oss.paths.0.lp)
	#oss.paths.0.rp)
	#oss.paths.0.tot)
	#oss.paths.0.free)
	#oss.paths.0.ino)
	#oss.paths.0.ifr)
	oss.space)
	    unit="Count"
	    name="subsequent space stats";;
	sched.jobs)
	    unit="Count"
	    name="jobs requiring new thread";;
	#sched.inq)
	#    unit="Count"
	#    name="jobs currently in run queue";;
	#sched.maxinq)
	#    unit="Count"
	#    name="max jobs in run queue";;
	sched.threads)
	    unit="Count"
	    name="current scheduler threads";;
	sched.idle)
	    unit="Count"
	    name="idle scheduler threads";;
	#sched.tcr)
	#sched.tde)
	sched.tlimr)
	    unit="Count"
	    name="number of times thread limit reached";;
   esac
   if [ "$name" != "" ]; 
     then
	gmetric -g 'Xrootd_usage' -n "$name" -v ${linearray[1]} -t 'double' -u "$unit" -d $METRIC_TTL
     fi
   fi
done < <(mpxstats -p1234 -f flat)


