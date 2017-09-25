#!/bin/sh
{
  echo hostname=$(hostname -s)
  echo domainname=$(hostname)
  echo DCLR_VOL=/srv/docker-volume-local
  echo MUNIN_USERS=$(whoami)
  echo MUNIN_PASSWORDS=$(whoami)
  echo NODES=boreas.zt
} > .env
