#!/bin/sh

#if [ $(id -u) -ne 0 ]; then
#   echo "This script must be run as root"
#   exit;
#fi

DATE=$(date +%F)

for f in hosts/*.sh; do
  HOST=$(basename $f | rev | cut -c4- | rev)

  if ! [ -f "archives/${HOST}-${DATE}.tgz" ]; then
    ssh $HOST 'bash -s' < $f
    scp ${HOST}:/srv/backup.tgz .
    ssh $HOST 'rm /srv/backup.tgz'
    mv backup.tgz archives/${HOST}-${DATE}.tgz
  else
    echo "$HOST already has backup dated for today, skipping..."
  fi
done

scp archives/*.tgz cvrserver@cvr-server:c:/Users/Public/Backups/Automated
