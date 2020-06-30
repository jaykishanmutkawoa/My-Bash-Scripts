#!/usr/bin/env bash
## Author: Jmutkawoa@cyberstorm.mu

Email="xxx@xxx.net"
BackDir="/opt/wh/backup/daily"
DateDay=$(date +"%Y-%m-%d")
EA2BackupDirectory="/home/wh/EA2_Backup"
EA2Source="/home/wh/wip/eaggv2/"
LogFile="${EA2BackupDirectory}/log/EA2Backup-$DateDay.log"
RedisDB="${EA2Source}dump.rdb"
printf "%(%d-%m-%Y-%H:%M:%S)T - Starting backup script for he Email Aggregator database -- OK\n" -1 > "$LogFile"
function SendMailIfError()
{

/usr/bin/grep -e "-- ERROR" "$LogFile" > /dev/null
Result=$?
if [ "$Result" -eq 0 ] ; then
        /usr/bin/mail -s "EA2 Backup ERROR" $Email < "$LogFile"
else
exit 200
fi
}

function DBDump()
{
        local mydb=$1
        local skip=$3
        printf "%(%d-%m-%Y-%H:%M:%S)T - Checking if databases exist first.. -- OK\n" -1 >> "$LogFile"
        if ! /usr/bin/mysql -e "use $mydb" >> "$LogFile" 2>&1  ; then
                printf "%(%d-%m-%Y-%H:%M:%S)T - Please Escalate - $mydb Does the databases exist? -- ERROR\n" -1 >> "$LogFile" ;
                SendMailIfError ;
                exit
        fi
        printf "%(%d-%m-%Y-%H:%M:%S)T - Proceeding to dump MySQL database $mydb -- OK\n" -1 >> "$LogFile"
        /usr/bin/mysqldump "$mydb" "$skip"  | gzip -9 > $EA2BackupDirectory/MySQLDB/"$mydb".sql.gz
}

function BackUpRedisDB()
{
        if /usr/sbin/lsof -Pi :6378 -sTCP:LISTEN -t >> "$LogFile" 2>&1 ; then
                printf '%(%d-%m-%Y-%H:%M:%S)T - Initiating backup of Redis DB which listen on port 6378 --- OK\n' -1 >> "$LogFile" ;
         /usr/bin/redis-cli -p 6378 save >> "$LogFile" 2>&1
        else
                printf '%(%d-%m-%Y-%H:%M:%S)T - Is Redis server listening on port 6378? --- ERROR\n' -1 >> "$LogFile" ;
         SendMailIfError;
                exit
        fi

        mapfile -t < <(stat $RedisDB | grep Modify | awk '{print $2}') ;
                for i in "${MAPFILE[@]}"; do

