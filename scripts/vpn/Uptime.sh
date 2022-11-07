#!/bin/bash

time=$1

D=""
H=""
M=""

if ((time < 3600000)); then
    M=$((time / 1000 % 60))
elif ((time < 86400000)); then

    H=$((time / 3600000))
else
    D=$((time / 86400000))
fi

if ((D > "0")); then
    result="🆙${D}:day"
elif ((H > "0")); then
    result="🆙${H}:hour"
elif ((M > "0")); then
    result="🆙${M}:min"
else
    result="🤔Unknow"
fi

echo "$result"
