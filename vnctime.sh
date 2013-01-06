#!/bin/bash
#===============================================================================
#         FILE: vnctime
#
#        USAGE: ./vnctime 
# 
#  DESCRIPTION: Connect to an existing vnc session via SSH
# 
#      OPTIONS: -k: kills existing session (if any)
# REQUIREMENTS: VNC session must exist on server and must not be in use already
#     PACKAGES: tigervnc (fc17.x86_64)
#         BUGS: ---
#        NOTES: ---
#      CREATED: 02/04/2012 01:50:22 PM CDT
#     REVISION: 0.2
#===============================================================================

# Editable variables
local_port="5901"
server_port="5909"
server="example.domain.com"
sleep_delay="5"

# Case to kill previous or stale session
case "$1" in
	-k	)
	for i in `/bin/ps aux | egrep "vncviewer|$local_port\:localhost\:$server_port" | grep -v grep | awk '{print $2}'`; do kill $i && if [ echo $i -ne 0 ]; then kill -9 $i; fi; done

	;;
	-5	)
	slumber=$sleep_delay
	;;
	*	)
	slumber=1
	;;
esac

# for key-based connections (recommended)
ssh-add -l

# start SSH port-forwarding
if [ `/bin/ps aux | grep $local_port\:localhost\:$server_port | grep -v grep | wc -l` -eq 0 ]
then 
	/usr/bin/ssh -t -t -l hinc -L $local_port:localhost:$server_port $server &
	sleep $slumber
fi
/usr/bin/vncviewer localhost:1 &
