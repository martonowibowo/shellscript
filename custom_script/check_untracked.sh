#!/bin/bash

check(){
path=$1
file=$2

if result=$(cd ${path} && git status | grep -n Untracked | cut -f1 -d:);then
echo $result 
line=$(cd ${path} && git status | wc -l)
echo $line
row1=$((result+3))
echo $row1
row2=$((line-1))
git status | awk 'NR>=$row1,NR<$row2 {print $2}'

#sh /tmp/result.${file} | awk '{print $5" "$7" "$6" "$8" "$9}'
else
echo nothing modified
fi
}
path_folder=$1
check /opt/public_html/${path_folder} ${path_folder}
#files=($(ls /opt/public_html/))
#for item in ${files[*]}
#do
#echo $item 
#check /opt/public_html/$item $item
#done
