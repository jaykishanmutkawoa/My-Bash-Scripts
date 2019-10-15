# Author: jmutkawoa@cyberstorm.mu
# bash script to check if file exist or not

# To launch it just point the script to the file. Example:
# ./CheckIfFileExist.sh ./location/of/your/file

#!/usr/bin/bash

file="$1"

if [ -f "$file" ];
	then
echo "$file exist on the machine"
	else
echo "$file do not exist on the machine"
fi
