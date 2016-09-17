#!/usr/bin/env bash

set -e
source /backupper_bin/includes.sh

BACKUP_NUM=$1
BACKUP_NAME=$2

BACKUP_DB_HOST=`get_variable "BACKUP_DB_HOST_$BACKUP_NUM"`
if [ "$BACKUP_DB_HOST" = "" ]; then echo "> Default BACKUP_DB_HOST will be setup"; BACKUP_DB_HOST='localhost'; fi

BACKUP_DB_PORT=`get_variable "BACKUP_DB_PORT_$BACKUP_NUM"`
if [ "$BACKUP_DB_PORT" = "" ]; then echo "> Default BACKUP_DB_PORT will be setup"; BACKUP_DB_PORT='5432'; fi

BACKUP_DB_NAME=`get_variable "BACKUP_DB_NAME_$BACKUP_NUM"`
if [ "$BACKUP_DB_NAME" = "" ]; then echo "> Default BACKUP_DB_NAME will be setup";BACKUP_DB_NAME='template1'; fi

BACKUP_DB_USER=`get_variable "BACKUP_DB_USER_$BACKUP_NUM"`
if [ "$BACKUP_DB_USER" = "" ]; then echo "> Default BACKUP_DB_USER will be setup";BACKUP_DB_USER='postgres'; fi

BACKUP_DB_PASSWORD=`get_variable "BACKUP_DB_PASSWORD_$BACKUP_NUM"`
if [ "$BACKUP_DB_PASSWORD" = "" ]; then echo "> Default BACKUP_DB_PASSWORD will be setup";BACKUP_DB_PASSWORD=''; fi

BACKUP_OPTIONS=`get_variable "BACKUP_OPTIONS_$BACKUP_NUM"`
if [ "$BACKUP_OPTIONS" = "" ]; then echo "> Default BACKUP_OPTIONS will be setup";BACKUP_OPTIONS=''; fi

BACKUP_DIR=`get_variable "BACKUP_DIR_$BACKUP_NUM"`
if [ "$BACKUP_DIR" = "" ]; then echo "> Default BACKUP_DIR will be setup";BACKUP_DIR='/data'; fi


#YEAR=`date +%Y`
#MONTH=`date +%m`
#DAY=`date +%d`
#BACKUP_DIR="$BACKUP_DIR/$YEAR/$MONTH/$DAY"
[ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR";


DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M:%S`
BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME"_"$DATE"_"$TIME.sql"

echo "===DOING BACKUP (`date`)==="
echo "> Backupper NUMBER: $BACKUP_NUM"
echo "> Backupper NAME: $BACKUP_NAME"
echo "> BACKUP_DB_HOST: $BACKUP_DB_HOST"
echo "> BACKUP_DB_NAME: $BACKUP_DB_NAME"
echo "> BACKUP_DB_USER: $BACKUP_DB_USER"
echo "> BACKUP_DB_PASSWORD: ******"
echo "> BACKUP_OPTIONS: $BACKUP_OPTIONS"
echo "> BACKUP_DIR: $BACKUP_DIR"
echo "> BACKUP_FILE: $BACKUP_FILE"

PGPASSWORD="$BACKUP_DB_PASSWORD" pg_dump --no-password --host="$BACKUP_DB_HOST" --port="$BACKUP_DB_PORT" --username="$BACKUP_DB_USER" --dbname="$BACKUP_DB_NAME" $BACKUP_OPTIONS --file "$BACKUP_FILE"
echo "===BACKUP IS DONE==="