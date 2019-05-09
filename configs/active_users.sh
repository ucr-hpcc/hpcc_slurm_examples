#!/bin/bash -l

IFS=$'\n'

for SUSER in $(getent passwd | egrep -v "disabled|nfsnobody"); do
    if [[ $(echo ${SUSER} | cut -d: -f3) -ge 1000 ]]; then
        echo $(echo $SUSER| cut -d: -f1);
    fi
done

