#!/bin/bash
#set -x
iran_gateway="x.x.x.x"
input="iran_ips.txt"
getopts 'arh' OPTION;
#echo $OPTION
case "$OPTION" in
  a)
    while IFS= read -r line
    do
      #echo "add $line"
      route add -net $line gw $iran_gateway metric 50
    done < "$input"
    ;;
  r)
    while IFS= read -r line
    do
      #echo "del $line"
      route del -net $line
    done < "$input"
    ;;
  h|*)
    echo "Use -a to add and -r to remove routes. -h for help"
    ;;
esac
