#!/bin/bash 
# Postgres backup
DATE=`date +%Y-%m-%d:%H:%M:%S`;export PGPASSWORD="skwxhStJ";pg_dump -U passanager -h localhost -d passanager -f /shareddb/backup_$DATE.sql