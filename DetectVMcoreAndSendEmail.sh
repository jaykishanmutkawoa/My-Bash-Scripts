#! /bin/bash
# AUTHOR:Jaykishan MUTKAWOA (jmutkawoa@gmail.com

purge=`find /home/crash -mtime +40 -type f -name 'vmcore' -exec rm -rf {} \;`
check=`find /home/crash -name "vmcore" -type f`
size=`du -csh /home/crash/vmcore`
Result=$?
if [ "$Result" -eq 0 ]
then
echo "vmcore crash detected on server. This file is going to be deleted in 40 days. Size of file is : $size" | mail -s test-test-test xxx@xxx.com
exit 0
else
exit 1
fi
