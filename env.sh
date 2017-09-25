#!/bin/sh

{
  echo hostname=$(hostname -s)
  echo domainname=$(hostname)
  echo DCLR_VOL=/srv/docker-volume-local
  echo MUNIN_USERS=$(whoami)
  echo MUNIN_PASSWORDS=$(whoami)
  echo NODES=boreas.zt
} > .env

export add_hostlist="$(
  grep '[a-z-]*.zt' /etc/hosts |
    awk '{print "--add-host "$2":"$1}' |
      tr '\n' ' ' )"
