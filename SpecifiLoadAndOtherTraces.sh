#!/bin/bash

# ==================== Author Nitin Mutkawoa ====================
# ============== Email mutkawoa.nitin@orange.com ================

# This script is to take out traces during load on FST platform.
PostgresLog="/usr/local/lib/ctera/postgres/pg_log/"
WorkDirCtera="/usr/local/lib/ctera/"
TmpDir="/tmp/"
Date=$(date +"%d-%m-%Y-%H-%M-%S")
Hostname=$(hostname)
host=localhost
cmd1=print-db-connections-threads-stack-trace
Capacity=80
mkdir -p "${WorkDirCtera}"LogToBeSentToCtera/
function CteraDump()
{
        echo "Performing Dumps on machine using Ctera Script"
        /usr/local/ctera/bin/ctera-dump.sh "$1"
}
function RetrievePostgresLog()
{
        echo "copying postgres logs"
        find "${PostgresLog}" -maxdepth 1 -mtime -2 -type f -name "*.log" | xargs cp -t "${WorkDirCtera}LogToBeSentToCtera"
}
function RetrieveCteraDump()
{
        echo "Retrieving CTERA dumps"
        find "${WorkDirCtera}" -maxdepth 1 -mtime -2 -type f -name "dump.*" | xargs cp -t "${WorkDirCtera}LogToBeSentToCtera"
}
function CompressLogs()
{
        echo "Compressing directory LogToBeSentToCtera"
        if zip -rj "${WorkDirCtera}"LogToBeSentToCtera."$Date"."$Hostname".zip "${WorkDirCtera}LogToBeSentToCtera"; then
        echo "Compression succesful"
        else
        echo "There is an error whilst compressing the Log"
        exit 30
        fi
}
function Cleaning()
{
        echo "Cleaning old logs created by this script"
        if ! rm -rf "${WorkDirCtera}"LogToBeSentToCtera ; then
        echo "Cleaning failed"
        else
        echo "Cleaning succesful"
        exit 31
        fi
}
function check_disk()
{

        if ! [ $(df -P $WorkDirCtera | awk '{ gsub("%",""); capacity = $5 }; END { print capacity }') -gt $Capacity ]
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
CteraDump
        if ! /usr/local/ctera/postgres/bin/psql -X -U postgres -f /usr/local/ctera/postgres/statfull.sql > /tmp/SQLOutput/StatFullScript.txt; then
echo "psql failed while trying to run this statfull script"
exit 20
        fi
        if ! /usr/local/ctera/postgres/bin/psql -X -U postgres -f /usr/local/ctera/postgres/waitingfull.sql > /tmp/SQLOutput/WaitingFullScript.txt; then
echo "psql failed while trying to run this waitingfull script"
exit 20
        fi
        if ! /usr/local/ctera/postgres/bin/psql -X -U postgres -f /usr/local/ctera/postgres/psqllocksfull.sql > /tmp/SQLOutput/PsqlLocksScript.txt; then
echo "psql failed while trying to run this PsqlLock script"
exit 20
        fi
RetrieveCteraDump
        if ! mv "${TmpDir}SQLOutput" "${WorkDirCtera}"LogToBeSentToCtera ; then
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
CteraDump "-m"
RetrieveCteraDump
CompressLogs
Cleaning
elif [[ $(hostname -s) = *DBMASTER* ]]; then
 echo "This machine is the DBMASTER"
check_disk
CteraDump
RetrieveCteraDump
RetrievePostgresLog
CompressLogs
Cleaning
 exit 100
fi


