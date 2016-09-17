# pg-backupper
Docker image to do scheduled backups of PostgreSQL DBs

This Dockerfile can be used to do daily backups and cleanup archive with a policy like this:

* Do backups every X hours
* Keep at least one backup for each of X last days (last backup for all previous days)
* Keep at least one backup for each of X last weeks (e.g. for each Monday of last 2 weeks)
* Keep at least one backup for each of X last months (e.g. for each 3d day of any last 5 month)

# Configuration

You can have as many connections to backup as you want (maximum number is 99 though) and for each of it you need to have a config like this:

* `BACKUP_NAME_[1..99]` - Name which will be used to generate backup files.
* `SCHEDULE_[1..99]` - Cron format for running backups (e.g. `23 */3 * * *`). Default: `0 0 * * *`
* `BACKUP_DIR_[1..99]` - Directory to keep backups. Default: `/data`
* `BACKUP_DB_HOST_[1..99]` - DB host to backup. Default: `localhost` 
* `BACKUP_DB_PORT_[1..99]` - DB port to backup. Default: `5432` 
* `BACKUP_DB_NAME_[1..99]` - DB name to backup. Default: `template1` 
* `BACKUP_DB_USER_[1..99]` - DB use to backup. Default: `postgres`
* `BACKUP_DB_PASSWORD_[1..99]` - DB use to backup.  Default: `` (empty string)
* `BACKUP_OPTIONS_[1..99]` - [options](https://www.postgresql.org/docs/9.5/static/app-pgdump.html#PG-DUMP-OPTIONS) `pg_dump` utility. Default: `` (empty string)
* `SAFE_DAYS_[1..99]` - Number of days when we keep one backup per each day. Default: `7`
* `SAFE_WEEKS_[1..99]` - Number of weeks when we keep backup per each week. Default: `4`
* `SAFE_WEEK_DAY_[1..99]` - Name of the Day of the Week to keep backup. Valid values: `Monday,Tuesday, Wednesday,Thursday,Friday,Saturday,Sunday` Default: `Monday`
* `SAFE_MONTHS_[1..99]` - Number of months when we keep one backup per each month. Default: `6`
* `SAFE_MONTH_DATE_[1..99]` - Date of any month to keep backup. Valid values: `1-28`. Default: `1`

In fact Docker container will have cron which will run `pg_backup` and proceed cleanup of old backups accordingly configs for each of provided connections.