#!/bin/bash

# ============== Email jmutkawoa@gmail.com ================

PostgresLog="/usr/local/lib/postgres/pg_log/"
WorkDir="/usr/local/lib/"
TmpDir="/tmp/"
Date=$(date +"%d-%m-%Y-%H-%M-%S")
Hostname=$(hostname)
host=localhost
cmd1=print-db-connections-threads-stack-trace
Capacity=80
mkdir -p "${WorkDir}"LogToBeSentTo/
function Dump()
{
        echo "Performing Dumps on machine using specific Script"
        /usr/local/bin/dump.sh "$1"
}
function RetrievePostgresLog()
{
        echo "copying postgres logs"
        find "${PostgresLog}" -maxdepth 1 -mtime -2 -type f -name "*.log" | xargs cp -t "${WorkDir}LogToBeSentTo"
}
function RetrieveDump()
{
        echo "Retrieving dumps"
        find "${WorkDir}" -maxdepth 1 -mtime -2 -type f -name "dump.*" | xargs cp -t "${WorkDir}LogToBeSentTo"
}
function CompressLogs()
{
        echo "Compressing directory LogToBeSentTo"
        if zip -rj "${WorkDir}"LogToBeSentTo."$Date"."$Hostname".zip "${WorkDir}LogToBeSentTo"; then
        echo "Compression succesful"
        else
        echo "There is an error whilst compressing the Log"
        exit 30
        fi
}
function Cleaning()
{
        echo "Cleaning old logs created by this script"
        if ! rm -rf "${WorkDir}"LogToBeSentTo ; then
        echo "Cleaning failed"
        else
        echo "Cleaning succesful"
        exit 31
        fi
}
function check_disk()
{

        if ! [ $(df -P $WorkDir | awk '{ gsub("%",""); capacity = $5 }; END { print capacity }') -gt $Capacity ]
         then
        echo "Disk size is below $Capacity. Script is in progress :) "
         else
        echo "Disk is equal or greater than $Capacity. Script will now exit. Please Contact Astreinte L2 - on call :( "
         exit 200
        fi
}
if [[ $(hostname -s) = *DBCATA* ]]; then
 echo "This machine is a CATALOGUE server."
check_disk
mkdir -p "${TmpDir}"SQLOutput
Dump
        if ! /usr/local/postgres/bin/psql -X -U postgres -f /usr/local/postgres/statfull.sql > /tmp/SQLOutput/StatFullScript.txt; then
echo "psql failed while trying to run this statfull script"
exit 20
        fi
        if ! /usr/local/postgres/bin/psql -X -U postgres -f /usr/local/postgres/waitingfull.sql > /tmp/SQLOutput/WaitingFullScript.txt; then
echo "psql failed while trying to run this waitingfull script"
exit 20
        fi
        if ! /usr/local/postgres/bin/psql -X -U postgres -f /usr/local/postgres/psqllocksfull.sql > /tmp/SQLOutput/PsqlLocksScript.txt; then
echo "psql failed while trying to run this PsqlLock script"
exit 20
        fi
RetrieveDump
        if ! mv "${TmpDir}SQLOutput" "${WorkDir}"LogToBeSentTo ; then
        echo "failed to copy sql outputs"
        else
        echo "Retrieving Psql Outputs from tmp folder"
        fi
RetrievePostgresLog
CompressLogs
Cleaning
elif [[ $(hostname -s) = *PROD-FE* ]]; then
check_disk 
 echo "This machine is the FRONTAL node"

        if ( echo open ${host}
sleep 3
        echo ${cmd1}
sleep 3
        ) | telnet ; then
        echo "Telnet was sucessful"
        fi
Dump "-m"
RetrieveDump
CompressLogs
Cleaning
elif [[ $(hostname -s) = *DBMASTER* ]]; then
 echo "This machine is the DBMASTER"
check_disk
Dump
RetrieveDump
RetrievePostgresLog
CompressLogs
Cleaning
 exit 100
fi
