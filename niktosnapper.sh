# !/bin/bash

# Get the list of all hosts that need to be scanned
# Input: The file containing IP address listing in the form IP:Port
# Output: ips-listing.txt the file containing unique IPs 
# Version: 1.1 
# Updates: Support for auto SSL detection 
# 
max_niktos=25
NIKTO=`which nikto`
NIKTOCONF=/etc/nikto/config.txt
usage_display()
{
  echo " **************************************************** "
  echo " ******    niktopar - Nikto Parallelism        ****** "
  echo " **************************************************** "
  echo "  Author: Rajat Swarup  rajats@gmail.com"
  echo "  Usage : $0 <newline_delimited_list_of_ips> <no_of_nikto_processes>";
  echo "  "
  echo "  Default:  no_of_nikto_processes=30             "
}

# Spawn one nikto process per IP address
nikto_scan()
{
  for line in `cat $ips_listing`
  do 
   ip=`echo $line|awk -F ':' '{print $1}'` 
   port=`echo $line|awk -F ':' '{print $2}'`
   echo "$ip:$port"
   if [ $port -eq 443 ]
   then
     sslflag=1
   else
     sslflag=0
   fi
   if [ $sslflag -eq 1 ]
   then
    ( perl $NIKTO -config $NIKTOCONF -ssl -h $ip -port $port -o $ip-$port-ssl.html -Format htm 1>/dev/null ) &
   else
    ( perl $NIKTO -config $NIKTOCONF -h $ip -port $port -o $ip-$port.html -Format htm  1>/dev/null ) &
   fi
   wait_to_finish
  done
  wait
}

wait_to_finish()
{
  niktocount=`ps ahl | awk '{print $4}' | grep $$ | wc -l`

  while [ "$niktocount" -gt "$max_niktos" ] ;
  do
    niktocount=`ps ahl | awk '{print $4}' | grep $$ | wc -l`
  done ;
}
cleanup()
{
  rm -f ips-listing.txt
  rm -f test.txt
  rm -f dump.txt
}

cleanup
if [ $# -lt 1 ]
then
  usage_display
  exit -1 
else
  echo "The process ID of $0 is $$ "
  if [ -z "$2" ]
  then
    echo "No value specified for number of nikto processes; Default used : $max_niktos"
  else
    echo "Using $2 total nikto processes"
    max_niktos="$2"
  fi
  total_hosts=`wc -l $1| awk '{print $1}'` 
  echo "Number of hosts: $total_hosts"
  echo "Starting the niktoscan now..."
  ips_listing=$1
  nikto_scan
fi

