#!/bin/bash

#Author: jmutkawoa@gmail.com

## Purpose of script to check errors encountered during execution of lspath of AIX VIO server.

## Vars declared
vio="h1axxxxx-x0"
date=`date +%Y-%m-%d-%H:%M:%S`
LocalPath="/tmp/VIO-Output-$date"
mail="XXX.XXX@XXX.com"

## Information extracted
if ! ssh $vio 'lspath | egrep -v "Enabled|Available"' | sed '1s/^/Error on lspath - VIO Disks Report\n/' > $LocalPath; then
        echo "Can't execute lspath, Please check if VIO is reachable and if the command lspath can be launched there"
        exit 100
fi


## Sending Mail
if ! cat $LocalPath | mail -s "AIX checks - xxxx 2012 - VIO Notifications for failed disks" $mail; then
        echo "Cant send mail, please investigate locally on xxxx server"
        exit 200
fi

## Cleaning /tmp
if [ -f $LocalPath ]; then
        rm $LocalPath
fi
