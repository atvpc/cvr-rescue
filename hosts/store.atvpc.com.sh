#!/bin/sh

# due to the large amount of data, each step is broken up into
# smaller parts to make recovery more graceful and less time
# consuming

if ! [ -f /srv/backup.tar ]; then
  tar -cpf /srv/backup.tar /srv/htdocs

  mysqldump --all-databases --single-transaction --quick --lock-tables=false > /srv/mysqldump.sql
  tar -rf /srv/backup.tar /srv/mysqldump.sql
  rm /srv/mysqldump.sql
fi

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
