#!/bin/bash
parsepath=$(cat palomino_access.log  | awk '! /.jpg/ && ! /.png/ && !/.JPEG/ && !/.JPG/ && !/.js/ && !/.css/ && !/.gif/ && !/.woff/ && !/.ttf/ {print $7"-"$1}'|sort)
#echo "$parsepath"
pathlist=$(echo "$parsepath"|sort |uniq)
for path in ${pathlist[*]}
do
crot=$(echo "$parsepath" | grep $path |sort -nr|wc -l)
if [ "$crot" -gt "100" ]
then
echo "$crot : $path"
fi
done
