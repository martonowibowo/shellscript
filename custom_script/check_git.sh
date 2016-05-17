#!/bin/bash

check(){
path=$1
file=$2

if result=$(cd ${path} && git status | grep modified | awk '{print "ls -lah '${path}'/"$3}');then
echo "$result" > /tmp/result.${file} 2>&1 
sh /tmp/result | awk '{print $5" "$7" "$6" "$8" "$9}'
else
echo nothing modified
fi
}
path_folder=$1
check /opt/public_html/${path_folder} ${path_folder}
