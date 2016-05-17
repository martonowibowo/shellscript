#!/bin/bash

check(){
path=$1
file=$2

if result=$(cd ${path} && git status | grep Untracked );then
printout=$(cd ${path} && git clean --dry-run | awk '{print $3;}' | xargs ls -l | awk '{print "'${file}' "$6" "$7" "$8" "$9}')
echo "$printout"
else
echo no untracked
fi
}
files=($(ls /opt/public_html/))
for item in ${files[*]}
do
check /opt/public_html/$item $item
done
