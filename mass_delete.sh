#!/bin/bash

THISDOMAIN="/"

for LETTER in {a..z} 
do
	for CLIENT in $(mccli client show --domain=${THISDOMAIN}  | grep -i "^${LETTER}" | awk '{print $1}')
	do 
		##Skip the header
		if [ "${CLIENT}" != "Client" ]
		then
			./delete_backups.sh "${THISDOMAIN}" "${CLIENT}"
		fi
	done
done

exit 0
