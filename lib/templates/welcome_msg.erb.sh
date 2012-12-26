#!/bin/sh
# Oct 2012 ys

if [ "$METHOD" = loopback ]; then
    exit 0
fi

# Only run from ifup.
if [ "$MODE" != start ]; then
    exit 0
fi

issue='/etc/issue'
ip=`/sbin/ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{ print $2 }' | awk -F: '{ print $2 }'`
bs='\\\\'

echo "\
Ubuntu 12.04.1 LTS haji <%= @data.version %>, Oct 2012 ys

************************ IP ***************************
IPv4: $ip

*********************** Users *************************
usr: saya
pwd: s
Use the info above to login as an admin.

********************* Directories *********************
Open shared folders from host machine.
From windows
    Win+R then input: $bs$bs$ip$bs \bsaya
From mac
    In Finder CMD+K then input: smb://$ip/saya

******************** Documentation ********************
For detail info about this vm, see:
    /home/saya/documentation.html
" > $issue

