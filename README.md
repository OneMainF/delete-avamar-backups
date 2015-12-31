Scripts that delete Avamar backups (Use at your own risk)
The scripts will start on a date specified and then delete _ALL_ daily and weekly backups from that point on.

Scripts must be ran on the Avamar server

Usage - ./delete_backups.sh "BackupDomain" "Server Name" "Date to start deleting from"
Example - ./delete_backups.sh "/" "bigServer" "2015-12-20"

Deleting replicated backups
Usage - ./delete_replicated_backups.sh "Server Name" "Date to start deleting from"
Example - ./delete_replicated_backups.sh "bigServer" "2015-12-20"

This script does the same thing as delte_backups.sh but it will delete from the REPLICTE domian
Note - If you delete from the REPLICATE domain before you delete from the source domain the backups will rereplicate.
