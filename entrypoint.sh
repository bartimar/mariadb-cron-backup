#!/bin/bash
set -eo pipefail

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
	if [ -z "$MYSQL_HOST" ]; then
		MYSQL_HOST='mysql'
	else
		echo >&2 'warning: both MYSQL_HOST and MYSQL_PORT_3306_TCP found'
		echo >&2 "  Connecting to MYSQL_HOST ($MYSQL_HOST)"
		echo >&2 '  instead of the linked mysql container'
	fi
fi

	if [ -z "$MYSQL_HOST" ]; then
	echo >&2 'error: missing MYSQL_HOST and MYSQL_PORT_3306_TCP environment variables'
	echo >&2 '  Did you forget to --link some_mysql_container:mysql or set an external db'
	echo >&2 '  with -e MYSQL_HOST=hostname?'
	exit 1
fi

# set cron schedule TODO: check if the string is valid (five or six values separated by white space)
[[ -z "$CRON_SCHEDULE" ]] && CRON_SCHEDULE='0 2 * * *' && \
   echo "CRON_SCHEDULE set to default ('$CRON_SCHEDULE')"

# get password from ENV variable, if empty, get it from linked mysql container
: ${PASSWORD:=${MYSQL_ROOT_PASSWORD:-$MYSQL_ENV_MYSQL_ROOT_PASSWORD}}

# add a cron job
echo "$CRON_SCHEDULE root rm -rf /backups/* && mysqldump -uroot -p"$MYSQL_ENV_ROOT_PASSWORD" --all-databases --single-transaction --force -h "$MYSQL_HOST" | gzip > /backups/dump" >> /etc/crontab
crontab /etc/crontab

exec "$@"
