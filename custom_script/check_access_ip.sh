#!/bin/bash
parsepath=$(cat palomino_access.log  | awk '! /.jpg/ && ! /.png/ && !/.JPEG/ && !/.JPG/ && !/.js/ && !/.css/ && !/.gif/ && !/woff/ && !/tiff/ {print $1" "$7}')
iplist=$(echo "$parsepath" |cut -d ' ' -f 1 |sort |uniq)
for ip in ${iplist[*]}
do
crot=$(echo "$parsepath" | grep $ip |sort -nr|wc -l)
echo "$crot : $ip"
done
