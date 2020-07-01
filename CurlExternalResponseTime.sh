#!/bin/bash

# Author: jmutkawoa@gmail.com

URL="https://tunnelix.com"

RESULT=$(curl -o /dev/null -s -w "Time:%{time_total} Status:%{http_code}" $URL)

date=$(date)

echo "$RESULT-$date" >> /home/output/result_external.txt
