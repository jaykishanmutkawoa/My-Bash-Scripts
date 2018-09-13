#!/bin/bash
#Author: jmutkawoa@gmail.com

# Script to perform client source code deployment from FTP server to Production.
# Always check for return code on error received from the script.

# Further prechecks were carried out to ensure good running of the modifications.

####################################################################################################################
################### PLEASE CHANGE VALUE OF 'FILE & 'TICKET' HERE BEFORE LAUNCHING THIS SCRIPT ######################
####################################################################################################################
####################################################################################################################
############################### PARAMETER TO BE MODIFIED SECTION ###################################################

file="r8538.zip" ## FILE NAME SHOULD END UP WITH ZIP
ticket="112333232386878787"  ## TICKET NUMBER HERE

####################################################################################################################
####################################################################################################################

date=`date +%Y-%m-%d`
ftpsource="/ftp/directory/path/here/$file"
lmdp="www.websitename.fr"
sourcedir="/data/www/$lmdp"
host="servername or IP"
backdir="/data/deployment/$ticket"

###### Some prechecks appended to log.

if ! ssh $host "test -e $ftpsource"; then
              echo "File does not seem to exist on FTP REMOTE MACHINE. Please Check Parameter to be modified section."
              exit 100
      else
              echo "The remote file $file is well present on FTP server."
fi

if [ ! -d $backdir ]; then
                mkdir -p $backdir
        else
                echo "Directory with name $ticket already exist. Exiting now.."
                exit 200
fi

###### Actions here after Prechecks.

if ! tar -cvzf $backdir/$lmdp-$ticket-$date.tar.gz $sourcedir; then
                echo "backup failure"
                exit 300
        else
                echo "Backup Successfully carried out in the directory $backdir"

fi

if ! scp -rp $host:$ftpsource $backdir > /dev/null 2>&1; then
                echo "Transfered failed. Probable network error."
		exit 400
        else
                echo "The remote file $file has been transfered succesfully to the directory $backdir"

fi

if ! unzip -o $backdir/$file -d $sourcedir > /dev/null 2>&1; then
                echo "Decompression failed for some reasons. Please check Disk space"
                exit 500
        else
                echo "Decompression carried out succesfully on $sourcedir."
fi

if ! chown -R apache:apache $sourcedir > /dev/null 2>&1; then
                echo "Chown failed for some reasons."
                exit 600
        else
                echo "Ownerships changed succesfully on the directory $sourcedir"
fi


