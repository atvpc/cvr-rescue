#!/bin/sh

tar -cpf /srv/backup.tar /srv/htdocs
tar -rphf /srv/backup.tar /etc/guacamole
tar -rphf /srv/backup.tar /usr/local/bin

mysqldump --single-transaction --quick --lock-tables=false --databases guacamole > /srv/mysqldump.sql
tar -rf /srv/backup.tar /srv/mysqldump.sql
rm /srv/mysqldump.sql

if ! tar -tf /srv/backup.tar > /dev/null; then
  echo "something went wrong with archiving, scrapping tar"
  rm /srv/backup.tar
  exit 1
fi

gzip -c /srv/backup.tar > /srv/backup.tgz

if ! gzip -t /srv/backup.tgz > /dev/null; then
  echo "something went wrong with compression, scrapping tgz"
  rm /srv/backup.tgz
  exit 1
else
  rm /srv/backup.tar
fi
