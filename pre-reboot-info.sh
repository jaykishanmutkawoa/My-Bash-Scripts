EMAIL=jmutkawoa@cyberstorm.mu

echo "LINUX PRE-REBOOT INFORMATIONS" > /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==================netstat -ntplu=======================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
netstat -ntplu >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "====================ps -aux============================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
ps -aux >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "=======================df -h============================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
mount >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "=========================ifconfig========================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
ifconfig >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================ethtool eth0====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
ethtool eth0 >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "=========================ethtool eth1=====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
ethtool eth1 >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "=========================route -n==========================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
route -n >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================iptables -L======================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
iptables -L >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "===========================uname -a=========================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
uname -a >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================cat /etc/redhat-release====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
cat /etc/redhat-release >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================cat /etc/fstab====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
cat /etc/fstab >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================cat /proc/mounts====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
cat /proc/mounts >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "======================tail -n +1 /etc/sysconfig/network-scripts/ifcfg-*================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
tail -n +1 /etc/sysconfig/network-scripts/ifcfg-* >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "======================tail -n +1 /etc/sysconfig/network-scripts/route-*==================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
tail -n +1 /etc/sysconfig/network-scripts/route-* >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "==========================rpm -qa====================================================" >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos
rpm -qa >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "============================================================================================" >> /tmp/linux_pre-reboot_infos

echo "  " >> /tmp/linux_pre-reboot_infos
yum check-update >> /tmp/linux_pre-reboot_infos
echo "  " >> /tmp/linux_pre-reboot_infos

echo "============================================================================================" >> /tmp/linux_pre-reboot_infos


mail -s "linux_pre-reboot_infos `hostname`" $EMAIL < /tmp/linux_pre-reboot_infos

