#!/bin/sh
# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.
if [ true != "$INIT_D_SCRIPT_SOURCED" ] ; then
    set "$0" "$@"; INIT_D_SCRIPT_SOURCED=true . /lib/init/init-d-script
fi

### BEGIN INIT INFO
# Provides:          sysup.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: A daemon script which uploads uptime information to a remote host.
# Description:       Requires sysupload.php on public server or ssh-keygen and ssh-copy-id to remote host. Must be added to
#                    crontab @reboot or added as service. Should chmod 755.
### END INIT INFO

# Author: Bastian Tenbergen (bastian.tenbergen@oswego.edu)
# Version: 2020/02/25

while (true)
do
    date=$(date "+%Y/%m/%d-%H:%M:%S")
    addr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    ext_addr=$(curl -s http://ipecho.net/plain; echo;)
    hostname=$(hostname)
    uptime=$(uptime -p)
    message="$hostname @ $addr via $ext_addr, last seen: $date, $uptime"
    {
        #uncomment the following line for scp-mode. Requires ss-keygen and ssh-copy-id to remote host.
        #ssh user@example.com "echo $message > ~/public_html/$hostname.txt"
        #uncomment the following lines for www-mode. Requires sysupload.php script to exist at remote dir and dir possibly to be chmod 777.
        #urlmessage=$(echo $message | sed -r 's/ /+/g')
        #curl -m 2 "http://example.com/~user/sysupload.php?host=$hostname&data=$urlmessage"
    } || {
        echo "Host unreachable at $date." >> ./sysup.log
    }
    sleep 60
done
