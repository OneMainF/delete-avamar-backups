#!/bin/bash

THISHOST="$1"
FROMDATE="$2"

HOSTSTR=`mccli client show --recursive=true --domain=/REPLICATE | grep -i ${THISHOST} | grep -v "RETIRED" | awk '{print $1"~"$2}'`

THISHOST=`echo ${HOSTSTR} | cut -d "~" -f1`
THISDOMAIN=`echo ${HOSTSTR} | cut -d "~" -f2`

echo "Getting backups for ${THISDOMAIN}/${THISHOST}"
RET=`/usr/local/avamar/bin/mccli backup show --domain=${THISDOMAIN} --name=${THISHOST} --before=${FROMDATE} 2>&1 | grep -c "Client does not exist"`

if [ "${RET}" == "1" ]
then
	echo "No backups found for ${THISDOMAIN}${THISHOST}"
	exit
fi 

mccli backup show --domain=${THISDOMAIN} --name=${THISHOST} --before=${FROMDATE} --verbose=True 2>&1 | grep ^[1-2] | awk '{ print $1"~"$4"~"$7}' > "backups_${THISHOST}"

for LINE in $(grep -e '~D$\|~DW$' "backups_${THISHOST}")
do
	LABEL=`echo ${LINE} | cut -d "~" -f2`
	THISDATE=`echo ${LINE} | cut -d "~" -f1`

	if [ "${LABEL}" != "" ] && [ "${THISDATE}" != "" ]
	then
		echo "Deleting backup of ${THISHOST} from ${THISDATE} - label #${LABEL}"
		echo "mccli backup delete --force --domain=${THISDOMAIN} --name=${THISHOST} --created=\"${THISDATE}\" --labelNum=\"${LABEL}\"" >> "deletelog_${THISHOST}" 
		/usr/local/avamar/bin/mccli backup delete --force --domain=${THISDOMAIN} --name=${THISHOST} --created="${THISDATE}" --labelNum="${LABEL}" >> "deletelog_${THISHOST}"
		RET="$?"

		if [ "${RET}" -gt "0" ]
		then
			echo "Failed to delete backup"
			echo "Failed to delete backup" >> "deletelog_${THISHOST}"
		fi
	fi 
done

rm backups_${THISHOST}

