# Bluemix mariadb cron backup container

This image provides a cron daemon that runs daily backups from mysql to directory /backups/.

It is recommended to connect this directory to a VOLUME

Originally forked from AckeeCZ/mariadb


Following ENV variables CAN be specified (HAVE TO be specified if you won't use --link):
 - `MYSQL_HOST` contains the remote host (hostname or IP) connection string for mysqldump command line client option -h
 - `MYSQL_ROOT_PASSWORD` password of user `root` who has access to all dbs
 - `CRON_SCHEDULE` cron schedule string, default '0 2 * * *'

# How to run the container on Bluemix?

With --link to mariadb container

`cf ic run -v volume_name:/backups --link some_mariadb:mysql -e CRON_SCHEDULE='0 1 * * *' registry.eu-gb.bluemix.net/organization/image_name`

Without --link you need to specify the HOST (hostname or IP) and password

`cf ic run -v volume_name:/backups -e MYSQL_HOST=xxx.xxx.xxx.xxx -e MYSQL_ROOT_PASSWORD=my_secret_pw registry.eu-gb.bluemix.net/organization/image_name`
