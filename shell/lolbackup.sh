#!/bin/bash
TO=/path/to/backups
FROM=/home/foo/webroot/awesome_website
now=`date +"%F"`
NUM_TO_KEEP=3 # How many artefacts do you want to keep
[ -e /$TO/$now/backup_yes ] && echo "Already backup today" && exit 0 
cd $TO
export NUM_TOTAL=`find . -maxdepth 1 -type d | grep '^./' | wc -l` 
export NUM_TO_DEL=`expr $NUM_TOTAL - $NUM_TO_KEEP` 

[ $NUM_TOTAL -gt $NUM_TO_KEEP ] && for d in `ls -lt | grep '^d' | tail -${NUM_TO_DEL} | awk '{print $9}' | tr "\n" " "`; do echo rm -Rfv $TO/$d; done

echo "Backing up ... " 
mkdir -p $TO/$now/
rsync -av $FROM $TO/$now 
touch $TO/$now/backup_yes