#!/bin/bash
mkdir testdir;
if [ $# -lt 1 ]
then
  echo "Usage: $0 <iplist>"
  exit
fi
for server in `cat $1`
do
  for dirname in `showmount -e $server|grep ^/|awk '{print $1}'`
  do
    mount -t nfs -o nolock $server:$dirname testdir
    ls -laR testdir >>$server-$dirname.txt
    umount testdir
  done
done
