#!/bin/bash

check(){
path=$1
file=$2

if result=$(cd ${path} && git status | grep modified);then
#echo "$result" > /tmp/result.${file} 2>&1 
#sh /tmp/result.${file} | awk '{print $5" "$7" "$6" "$8" "$9}'
printout=$(cd ${path} && git diff --name-only | xargs ls -l | awk '{print "'${file}' " $5" "$7" "$6" "$8" "$9}')
echo "$printout"
else
echo nothing modified
fi
}
#path_folder=$1
#check /opt/public_html/${path_folder} ${path_folder}
files=($(ls /opt/public_html/))
for item in ${files[*]}
do
check /opt/public_html/$item $item
done
