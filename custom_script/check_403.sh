#!/bin/bash

check(){
path=$1
file=$2

if result=$(cat $1 | awk '$7!="/app/etc/local.xml" && $7!="/media/bannerpopup/" {print $9}' | grep 403);then
output=$(cat $1 | awk '$9 ~ "403" && $7!="/app/etc/local.xml" && $7!="/media/bannerpopup/" {print $1" "$4" "$7" "$9}')
printf "$1\n$output\n\n"
else
printf ""
fi
}

tolog=$(files=($(ls /var/log/nginx/*_access.log))
for item in ${files[*]}
do
check $item $item 
done)
NOW=$(date +"%d%m%y")
GZIP="/bin/gzip"
echo "$tolog"

#echo "$tolog" > /var/log/gitcheck/git-"$NOW".log
#$GZIP /var/log/gitcheck/git-"$NOW".log
