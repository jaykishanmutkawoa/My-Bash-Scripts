#!/bin/bash

# Author: jmutkawoa@cyberstorm.mu

#Dump MySQL table data into separate SQL files for a specified database.

[ $# -lt 3 ] && echo "DATABASE SEPERATE TABLES DUMP: $(basename "$0") <DatabaseHost> <DatabaseUser> <Database> [</Path/To/Directory>]" && exit 1

DatabaseHost=$1
DatabaseUser=$2
Database=$3
Directory=$4

[ -n "$Directory" ] || Directory=.
test -d $Directory || mkdir -p $Directory

echo -n "Database Password: "
read -r DatabasePassword
echo
echo "Dumping seperate SQL files tables for database '$Database' into dir=$Directory"

TableCount=0

for tables in $(mysql -NBA -h "$DatabaseHost" -u "$DatabaseUser" -p"$DatabasePassword" -D "$Database" -e 'show tables')
do
    echo "DUMPING TABLE: $Database.$tables"
    mysqldump -h "$DatabaseHost" -u "$DatabaseUser" -p"$DatabasePassword" "$Database" "$tables" | gzip -9 > $Directory/"$Database"."$tables".sql.gz
    TableCount=$(( TableCount + 1 ))
done

echo "$TableCount tables dumped from database '$Database' into dir=$Directory"
