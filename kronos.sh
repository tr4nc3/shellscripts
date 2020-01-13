#! /bin/bash
############################################################################
#
# Name:         Kronos
# Author:       Rajat 'trance' Swarup
# Mail bugs to: rajats@gmail.com
# Description:  This script looks for open NessusClient tmp files
#               and informs the user of the progress of the scan.
# Version:      1.3
# Date:         06 August 2009
# Changelog:    Fixed a bug where Nessus opens multiple temp files
#               Fixed a bug where Nessus creates multiple lines for same IP
#               Fixed a bug where > 100% could be achieved on completion :-)
#               Fixed a bug where less than default number of hosts are remaining
############################################################################

if [ $# -lt 1 -o $# -gt 3 ]
then
  echo "Script to find %age completion of Nessus scans"
  echo "Usage: $0 <file_with_all_ips_fed_to_NessusClient> {-verbose}"
  exit;
fi
verbose=0
nessusprocesses=15
nessusclicount=`ps uax | grep NessusCli | wc -l`
if [ $nessusclicount -lt 1 ]
then
  echo "Are you sure you have Nessus Client running?"
  echo "This script works for the old NessusClient only!"
  exit;
fi
if [ $# -eq 2 ]
then
  verbose=1
fi
completed=0
totaltime=0
if [ -e temp-kronos.txt ]
then
  rm temp-kronos.txt
fi
touch temp-kronos.txt
fname=`lsof | grep NessusCli | grep /tmp | gawk '{print $7" "$9}' | sort -r | head | gawk '{print $NF}'`
for ip in `cat $fname | grep host_start | sed 's/timestamps||//g' | cut -f 1 -d "|"`
do
  flag=`cat $fname | grep host_end | grep $ip | wc -l`
  if [ $flag -gt 0 ]
  then
    present=`grep $ip temp-kronos.txt| wc -l`
    inscope=`grep $ip $1|wc -l`
    if [ $present -lt 1 -a $inscope -gt 0 ]
    then
      let "completed += 1"
      echo $ip >>temp-kronos.txt
      if [ $verbose -gt 0 ]
      then
        starttime=`cat $fname | grep host_start | grep $ip |  cut -f 5 -d "|" | head -1`
        starttime=`date +%s --date="$starttime"`
        endtime=`cat $fname | grep host_end | grep $ip | cut -f 5 -d "|" | head -1`
        endtime=`date +%s --date="$endtime"`
        timetaken=`echo "$endtime-$starttime" | bc`
        let "totaltime += $timetaken"
        printf "Completed : %-16s in %5d seconds.\n" $ip $timetaken
      fi
    fi
  fi
done
linesinfile=`wc -l $1 | gawk '{print $1}'`
printf "Completion percentage %0.3f%%\n" `echo "($completed/$linesinfile)*100" | bc -l`
if [ $verbose -gt 0 -a $completed -gt 0 ]
then
  printf "Average time taken per host : %0.02f minutes\n" `echo "($totaltime/($completed*60))"|bc -l`
  if [ `expr $linesinfile-$completed` \< $nessusprocesses ]
  then
     $nessusprocesses=`expr $linesinfile-$completed`
  fi
  printf "Total remaining hours (nessus defaults): %0.2f hours\n" `echo "($totaltime*($linesinfile-$completed))/($completed*60*24*$nessusprocesses)" | bc -l`
fi

rm -f temp-kronos.txt