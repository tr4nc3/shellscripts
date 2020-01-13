#! /bin/bash
ARGS=3;
E_BADARGS=255;

test $# -lt $ARGS && echo "Usage: `basename $0` filename url root" && exit $E_BADARGS
rm -rf test.log;
# $1 is the parsed recursive directory file
for dirname in `cat $1`;
do
  echo $dirname | awk 'BEGIN {FS="\\"; RS="\n"; ORS=""} 
                            { 
                                for (j=1; j<= NF; j++)
                                { 
                                  for (i=j; i< NF; i++) 
                                  {
                                    print $i "/";
                                  }
                                  print $NF "\n"
                                }
                            } 
                        END {}'>>test.log; 
done;

for i in `cat test.log`
do
  x=`echo -ne $2 | awk '/.*/ gsub(/\/$/,"");'`;
  y=`echo -ne $3 | awk '/.*/ gsub(/\//,"");'`;
  URL=`echo -ne "$x/$y"`
  isHTTPS=`echo -ne $2 | grep https| wc -l`
  if [[ "$isHTTPS" -eq 1 ]]
    then
      cert="--no-check-certificate"
    else 
      cert="";
  fi
  #echo "$cert" " -a dload.log" "$URL/$i"
  wget $cert -a dload.log $URL/$i
done

rm -f dloaded-files.txt
grep -B 5 "200 OK" dload.log | awk '/^--/ {print $2}'>>dloaded-files.txt
