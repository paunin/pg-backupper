#!/usr/bin/env bash

set -e
source /backupper_bin/includes.sh

BACKUP_NUM=$1
BACKUP_NAME=$2


SAFE_DAYS=`get_variable "SAFE_DAYS_$BACKUP_NUM"`
if [ "$SAFE_DAYS" = "" ]; then echo "> Default SAFE_DAYS will be setup"; SAFE_DAYS='7'; fi

SAFE_WEEKS=`get_variable "SAFE_WEEKS_$BACKUP_NUM"`
if [ "$SAFE_WEEKS" = "" ]; then echo "> Default SAFE_WEEKS will be setup"; SAFE_WEEKS='4'; fi

SAFE_WEEK_DAY=`get_variable "SAFE_WEEK_DAY_$BACKUP_NUM"`
if [ "$SAFE_WEEK_DAY" = "" ]; then echo "> Default SAFE_WEEK_DAY will be setup"; SAFE_WEEK_DAY='Monday'; fi

SAFE_MONTHS=`get_variable "SAFE_MONTHS_$BACKUP_NUM"`
if [ "$SAFE_MONTHS" = "" ]; then echo "> Default SAFE_MONTHS will be setup"; SAFE_MONTHS='6'; fi

SAFE_MONTH_DATE=`get_variable "SAFE_MONTH_DATE_$BACKUP_NUM"`
if [ "$SAFE_MONTH_DATE" = "" ]; then echo "> Default SAFE_MONTH_DATE will be setup"; SAFE_MONTH_DATE='1'; fi

BACKUP_DIR=`get_variable "BACKUP_DIR_$BACKUP_NUM"`
if [ "$BACKUP_DIR" = "" ]; then echo "> Default BACKUP_DIR will be setup";BACKUP_DIR='/data'; fi

echo "===DOING CLEANUP (`date`)==="
echo " > Backupper NUMBER: $BACKUP_NUM"
echo " > Backupper NAME: $BACKUP_NAME"
echo " > BACKUP_DIR: $BACKUP_DIR"
echo " > SAFE_DAYS: $SAFE_DAYS"
echo " > SAFE_WEEKS: $SAFE_WEEKS"
echo " > SAFE_WEEK_DAY: $SAFE_WEEK_DAY"
echo " > SAFE_MONTHS: $SAFE_MONTHS"
echo " > SAFE_MONTH_DATE: $SAFE_MONTH_DATE"
php /backupper_bin/cleanup.php "$BACKUP_NAME" "$BACKUP_DIR" "$SAFE_DAYS" "$SAFE_WEEKS" "$SAFE_WEEK_DAY" "$SAFE_MONTHS" "$SAFE_MONTH_DATE"
echo "===CLEANUP IS DONE==="