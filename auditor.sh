#!/bin/bash
################################
#     Author: Rajat Swarup     #
#     Unix auditor script      #
#     Version: 0.1a            #
################################
fname=`echo \`date | sed 's/[:\ ]/_/g'\`-\`hostname\`-output.txt`
echo `uname -a`>>$fname
echo "Report for `hostname`">>$fname
echo "#########################################">>$fname
echo "*** Checking if root logins are restricted to console ***">>$fname
echo "#########################################">>$fname
cat /etc/default/login >>$fname
echo "#########################################">>$fname
echo " " >>$fname
echo "#########################################">>$fname
echo "*** Checking if /etc/passwd and /etc/shadow files have 1st line as root ***">>$fname
echo "#########################################">>$fname
cat /etc/passwd | head -1 | awk -F ':' '{print $1}' >>$fname
echo "#########################################">>$fname
echo " ">>$fname

echo "#########################################">>$fname
echo "First line of /etc/shadow is as follows:">>$fname
echo "#########################################">>$fname
cat /etc/passwd | head -1 | awk -F ':' '{print $1}' >>$fname
echo "#########################################">>$fname
echo " " >>$fname
echo "#########################################">>$fname
echo "*** Checking the sudoers file for no password ***">>$fname
echo "#########################################">>$fname
cat /etc/sudoers | grep NOPASSWD>>$fname
echo "#########################################">>$fname

echo "#########################################">>$fname
echo "*** Sudoers dump ***" >>$fname
echo "#########################################">>$fname
cat /etc/sudoers | grep -v '#' | grep -v ^$>>$fname
echo "#########################################">>$fname

echo "#########################################">>$fname
echo "**** Checking timeout ***">>$fname
echo "#########################################">>$fname
cat /etc/bash.bashrc | grep TMOUT >>$fname
echo "#########################################">>$fname
echo "#########################################">>$fname
echo "*** Is accounting software installed? **** ">>$fname
echo "#########################################">>$fname
which ac >>$fname
which lastcomm>>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Checking system IDs ***">>$fname
echo "#########################################">>$fname
cat /etc/passwd | grep -i"^adm\|^bin\|^checkfsys\|^daemon\|^lp\|^guest\|^makefsys\|^mountfsys\|^oasys\|^powerdown\|^setup\|^system\|^sync\|^sys\|^trouble\|^uucp\|^vmsys">>$fname
 echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "**** Checking unique group identifiers ****">>$fname
echo "#########################################">>$fname
cat /etc/group | awk -F ':' '{print $3}' |sort >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo " There are `cat /etc/group|grep :0:|wc -l` users with group ID 0" >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "The Command search path is : $PATH">>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Shadow file permissions ***">>$fname
echo "#########################################">>$fname
ls /etc/shadow >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** PAM Authentication ***">>$fname
echo "#########################################">>$fname
cat /etc/pam.d/login |grep -v '^#'|grep -v '^$'>>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** PASSWD File Permissions ***">>$fname
echo "#########################################">>$fname
ls /etc/passwd >>$fname
echo "#########################################">>$fname
echo " ">>$fname

logfname=`grep ^\`grep log /etc/sudoers | awk '{print $2}'|sed 's/=/ /g'|awk '{print $2}'\` /etc/syslog.conf|awk '{print $2}'`
echo "#########################################">>$fname
echo "*** Permissions on SULOG ***" >>$fname
echo "#########################################">>$fname
ls -al $logfname>>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Permissions on chfn and chsh ***">>$fname
echo "#########################################">>$fname
find /usr -name chsh  -exec ls -al {} \;  1>>$fname
find /usr -name chfn  -exec ls -al {} \;  1>>$fname
find /bin -name chsh -exec ls -al {} \;  1>>$fname
find /bin -name chfn -exec ls -al {} \;  1>>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Looking for .rhost files *** ">>$fname
echo "#########################################">>$fname
find / -name *.rhosts -exec ls -al {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Looking for .netrc files *** ">>$fname
echo "#########################################">>$fname
find / -name *.netrc -exec ls -al {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Getting a list of listening services ***">>$fname
echo "#########################################">>$fname
netstat -alp |grep \* |grep -i listen >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Getting a list of startup services ***">>$fname
echo "#########################################">>$fname
ls -al /etc/init.d |grep "tftp\|systat\|link\|finger\|rshell\|rlogin\|rexec\|talk\|echo\|discard\|daytime\|chargen\|rusers\|bootps\|gopher\|uucp\|ilmap\|pop\|netstat\|time\|linuxconf\|ntalk\|named\|httpd\|xmd\|snmp" >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Looking for hosts.equiv ***">>$fname
echo "#########################################">>$fname
find / -name hosts.equiv -exec ls -al {} \; >>$fname
find / -name host.lpd -exec ls -al {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** UMASK Value ***">>$fname
echo "#########################################">>$fname
umask >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Home directory permissions ***">>$fname
echo "#########################################">>$fname
ls -al /home >>$fname
ls -al / >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** Device file names ***">>$fname
echo "#########################################">>$fname
ls -la /dev >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** cron file permissions ***">>$fname
echo "#########################################">>$fname
find / -name cron.allow -exec ls -al {} \; >>$fname
find / -name cron.deny -exec ls -al {} \; >>$fname
find / -name cron* -exec ls -al {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** UUCP Permissions ***">>$fname
echo "#########################################">>$fname
grep uucp /etc/passwd >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** System file permissions ***">>$fname
echo "#########################################">>$fname
ls -al /bin >>$fname
ls -la /usr/bin >>$fname
ls -la /sbin >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** syslog settings ***">>$fname
echo "#########################################">>$fname
cat /etc/syslog.conf >>$fname
echo "#########################################">>$fname
echo " " >>$fname
echo "#########################################">>$fname
echo "*** finding suid root files ***">>$fname
echo "#########################################">>$fname
find / -type f -perm +6000 -exec ls -l {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** FTP daemon ***">>$fname
echo "#########################################">>$fname
find / -name *ftpd -exec ls -al {} \;>>$fname
echo "#########################################">>$fname
echo "*** SNMP daemon ***">>$fname
echo "#########################################">>$fname
ps aux |grep snmp >>$fname
find / -name snmpd.conf -exec cat {} \; >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** NIS Daemons running ***">>$fname
echo "#########################################">>$fname
ps aux |grep yp* >>$fname
echo "#########################################">>$fname
echo " ">>$fname
echo "#########################################">>$fname
echo "*** /etc/exports ***">>$fname
echo "#########################################">>$fname
cat /etc/exports >>$fname 
echo "#########################################">>$fname
echo " ">>$fname

