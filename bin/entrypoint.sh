#!/usr/bin/env bash

set -e

source /backupper_bin/includes.sh

CRON_FILE="/tmp/crontab.txt"
echo "" > "$CRON_FILE"

SED_EXPR='s/^\([A-Z0-9_]*\)=\(.*\)$/export \1="\2"/g'
printenv | grep BACKUP | sed "$SED_EXPR" > $ENV_FILE
printenv | grep SAFE | sed "$SED_EXPR"  >> $ENV_FILE


chmod +x $ENV_FILE

function setup_backupper {
    BACKUP_NUM=$1
    BACKUP_NAME=$2
    echo "    > Backupper NAME: $BACKUP_NAME"
    echo "    > Cron file: $CRON_FILE"

    SCHEDULE=`get_variable "SCHEDULE_$BACKUP_NUM"`

    if [ "$SCHEDULE" = "" ]
    then
        echo "    > Default schedule will be setup"
        SCHEDULE='0 0 * * *'
    fi
    echo "    > Backupper SCHEDULE: $SCHEDULE"

    echo "$SCHEDULE /backupper_bin/backup.sh $BACKUP_NUM $BACKUP_NAME > /var/log/backupper/$BACKUP_NAME-backup-last.log 2>&1" >> $CRON_FILE
    MINUTE=$(shuf -i 1-59 -n 1) #we should not proceed all cleanups in the same moment
    echo "$MINUTE */1 * * * /backupper_bin/cleanup.sh $BACKUP_NUM $BACKUP_NAME > /var/log/backupper/$BACKUP_NAME-cleanup-last.log 2>&1" >> $CRON_FILE
}

echo '> Setting up cron:'

touch "$CRON_FILE"



for BACKUP_NUM in `seq 1 99`
do
    BACKUP_NAME_VAR="BACKUP_NAME_$BACKUP_NUM"
    BACKUP_NAME="${!BACKUP_NAME_VAR}"
    if [ "$BACKUP_NAME" != "" ]
    then
        echo "  > Backupper number $BACKUP_NUM exists. Setting up schedule for it:"
        setup_backupper $BACKUP_NUM $BACKUP_NAME

    else
        TOTAL=$(($BACKUP_NUM-1))
        echo "> All $TOTAL backuppers have been setup"
        break
    fi

done
echo "=========================="
cat "$CRON_FILE"
echo "=========================="
cat "$CRON_FILE" | crontab -

echo "> Starting up cron(`date`)..."
cron -f
