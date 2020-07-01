#!/usr/bin/env bash

# Author: Jmutkawoa@cyberstorm.mu

## wordpress + mysql backup

Date=$(date +"%Y-%m-%d")
BackDir="/home/backup/"

## Replace xxx/xxx/xxx with the path of your source code
SourceCode="/xxx/xxx/xxx"
CopyFirst="${SourceCode}-$Date"
BackDirDate="${BackDir}WH-$Date"
MySQLcnf="/etc/my.cnf"
Nginxcnf="/etc/nginx/nginx.conf"

## Source code backup


## Replace websitename with the name you want the directory to be called
if [ -d "$SourceCode" ] ; then
        mkdir -p "$BackDirDate"
        cp -rp $SourceCode "$CopyFirst"
        tar -zcpf "$BackDirDate"/websitename-"$Date".tar.gz "$CopyFirst" > /dev/null
else
        exit
fi

## Backup of mysql

if ! /usr/bin/mysql -N -e 'show databases' | while read -r dbname;
        do mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > "$BackDirDate/$dbname".sql; done ; then
echo "error"
exit
fi

## Backup of mysql conf

if [ -f "$MySQLcnf" ] ; then
        cp "$MySQLcnf" "$BackDirDate"
fi

## Backup of Nginx conf

if [ -f "$Nginxcnf" ] ; then
        cp "$Nginxcnf" "$BackDirDate"
fi

