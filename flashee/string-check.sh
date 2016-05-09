#!/bin/sh
string="$1"
if echo "$1" | grep -q "acomindo"
then
    echo "ini adalah acomindo"
else
    echo "bukan situs acomindo"
fi
