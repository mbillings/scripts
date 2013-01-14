#!/bin/bash
#===============================================================================
#
#          FILE: brightness.sh
# 
#         USAGE: ./brightness <value 1 (darkest) to 15 (brightest)> 
# 
#   DESCRIPTION: Adjust laptop brightness
# 
#       OPTIONS: ---
#  REQUIREMENTS: sudo access to change ownership of a /sys file
#          BUGS: ---
#         NOTES: Tested on a Dell E6520 with Fedora 16 and 17.
#                Currently there is no error-checking, so don't be evil. 
#                Just enter a number between 0 (darkest) and 15 (brightest).
#  ORGANIZATION: ---
#       CREATED: A while ago
#      REVISION: 0.1
#===============================================================================

sneakyfile="/sys/class/backlight/acpi_video0/brightness"
me=`whoami`

# make sure we were given an argument
if [ -z "$1" ]
then echo "Usage: brightness.sh [0-15]"
     echo "Current value: " `cat $sneakyfile`
     exit 1
fi

# make sure we own the brightness file
if [ ! -O "$sneakyfile" ]
then sudo chown "$me" "$sneakyfile"
fi

# make sure we can write to the brightness file
if [ ! -w "$sneakyfile" ]
then sudo chmod u+w "$me" "$sneakyfile"
fi

# write the new value
if [ "$1" -ge 15 ]
then sudo echo 15 > $sneakyfile
else	
  if [ "$1" -le 0 ] 
  then sudo echo 0 > $sneakyfile
  else sudo echo "$1" > $sneakyfile
  fi
fi

