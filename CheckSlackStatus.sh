#!/usr/bin/env bash
# jmutkawoa@gmail.com

URL="https://status.slack.com"
EMAIL="Put your emaill here"

/usr/bin/curl --silent $URL | grep -o -E "Slack is up and running" > /dev/null

if [ $? -ne 0 ]
 then
/usr/bin/mail -s "SLACK is having an issue" $EMAIL <<< 'Check https://status.slack.com -- Something wrong with Slack'
fi
