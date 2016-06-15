#!/usr/bin/env bash


export DCKR_CONF=$HOME/.conf/dckr hostname=vs1


/usr/bin/docker run -d \
  --name ${hostname}-munin-server \
  --hostname munin.${hostname}.lan \
  --env-file=$DCKR_CONF/scalingo_munin-env.sh \
  -v $DCKR_VOL/munin/logs:/var/log/munin:rw \
  -v $DCKR_VOL/munin/db:/var/lib/munin:rw \
  -v $DCKR_VOL/munin/run:/var/run/munin:rw \
  -v $DCKR_VOL/munin/cache:/var/cache/munin:rw \
  -v /etc/localtime:/etc/localtime:ro \
  -e NODES='vs1.lan:192.168.9.31 dandy.lan:192.168.9.3' \
  \
  bvberkum/munin-server

