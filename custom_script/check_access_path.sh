
#!/bin/bash
parsepath=$(cat palomino_access.log  | awk '!/index.php/ &&! /.jpg/ && ! /.png/ && !/.JPEG/ && !/.JPG/ && !/.js/ && !/.css/ && !/.gif/ && !/.woff/ && !/.ttf/ {print $6"-"$7"-"$1}'|sort)
echo "$parsepath" > /tmp/parsepath
tmp=/tmp/parsepath
pathlist=$(cat $tmp|sort |uniq)
for path in ${pathlist[*]}
do
crot=$(cat $tmp | grep $path |sort -nr|wc -l)
if [ "$crot" -gt "50" ]
then
echo "$crot : $path"
fi
done
