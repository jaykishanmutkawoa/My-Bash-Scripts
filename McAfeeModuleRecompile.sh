#!/bin/bash

 

# Author j.mutkawoa@gmail.com


service="nailsd"

basedir="/opt/NAI/LinuxShield"

path="$(dirname $0)/../../sbin/"

 

if ! [ -d "${basedir}" ]; then

        echo "Directory: ${basedir} not present"

        exit 0

fi

 

#Verify if Mcafee processus is working

if ! pgrep $service > /dev/null; then

        echo "$service is not running"

        exit 0

fi

 

if ! which rpm > /dev/null 2>&1; then

        echo "Work only on rpm distrib"

        exit 1

fi

 

#Compare McAfee kernel modules with that of kernel version

#If version does not match stop AV otherwise exit

function avActions()

{

        /etc/init.d/nails $1

}

 

# Clean useless mcafee kernel module

function cleanModule()

{

 

        dir="$1"

 

        if [ -d "${dir}" ]; then

                cd ${dir}

                for module in $(ls *.{o,ko} 2>/dev/null); do

                        mversion=$(echo "${module}" | sed -e 's/-[^-]\+.k\?o$//g')

                        if ! rpm -q kernel-${mversion} >/dev/null 2>&1; then

                                rm -v -f "${module}"

                        fi

                done

                cd -

        fi

 

}

 

### Clean useless mcafee kernel module (kernel is not installed anymore)

cleanModule "${basedir}/lib/modules"

cleanModule "${basedir}/lib/modules-back"

 

# McAfee module already exist, nothing to do

kversion=$(uname -r)

if [ "$($path/uname -r)" == "$kversion" ]; then

        if [ -f "${basedir}/lib/modules/$kversion-linuxshield.ko" -a -f "${basedir}/lib/modules/$kversion-lshook.ko" ]; then

                echo "Nothing to do"

                exit 0

        fi

fi

 

avActions "stop"

 

#Backup all modules under /opt/NAI/LinuxShield/lib/modules to modules-back. Mcafee modules to be used manually incase of kernel rollback

mkdir -p "${basedir}/lib/modules-back"

mv -f "${basedir}/lib/modules/"*.{o,ko} "${basedir}/lib/modules-back/"

 

#Correct files containing MD5 hashes in installation folder

egrep -v '(linuxshield\.o|linuxshield\.ko|lshook\.o|lshook.ko)' "${basedir}/etc/md5" > "${basedir}/etc/md5.new"

mv -f "${basedir}/etc/md5"{.new,}

 

# Check  prerequisites and apply for RPM based machines only

if which yum > /dev/null 2>&1; then

        yum -y install kernel-devel kernel-headers gcc make

fi

 

#Override uname in PATH to fake McAfee compilation system

PATH="$path:$PATH"

 

# Compile the modules if return value is 0 start AV otherwise exit on value 100

if "${basedir}/bin/khm_setup" -c; then

        avActions "start"

        exit 0

else

        exit 100

fi
