#!/bin/bash
#set -x
input="routes.bk"
me=`basename "$0"`
getopts 'brtf' OPTION;
#echo $OPTION
case "$OPTION" in
  b)
    ip r | tac > routes.bk
    echo "backup $(cat routes.bk | wc -l) routes to $input"
    ;;
  r)
    echo "routes in $input will restore after $2 seconds"
    sleep $2

    #Remove all routes
    ./$me -f

    #Restore all routes
    echo "add $(cat $input | wc -l) routes"
    while IFS= read -r line
    do
      ip route add $line
    done < "$input"
    ;;
  f)
    routes="/tmp/routes_to_flush.bk"
    ip route show | tac > $routes
    echo "flush all $(cat $routes | wc -l) routes"
    while IFS= read -r line
    do
      ip route del $line
    done < "$routes"
    ;;
  t)
    ./$me -b
    ./$me -r $2
    ;;
  i)
    apt update
    apt install coreutils iproute2
  h|*)
    echo -e "\nThis command backups and restore routes after specific time"
    echo "-f Flush routing table"
    echo "-b Backup routes."
    echo -e "-r Restore routes after time in seconds.\n\t Example: route_backup_restore.sh -b 300"
    echo -e "-t Backup routes and restore after time in seconds\n\t Example: route_backup_restore.sh -t 300"
    echo -e "-i install all needed packages for this command on ubuntu"
    echo -e "-h For help\n"
    ;;
esac
