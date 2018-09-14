#!/bin/bash

URL="https://127.0.0.1/test"

RESULT=`curl -o /dev/null -s -w "Time:%{time_total} Status:%{http_code}" -k -H "HOST:www.tunnelix.com" $URL`

date=`date`

#echo $RESULT

echo "$RESULT-$date" >> /home/output/curllocal.txt
