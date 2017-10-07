# Docker image for munin server

[![](https://images.microbadger.com/badges/image/bvberkum/munin-server.svg)](https://microbadger.com/images/bvberkum/munin-server "Get your own image badge on microbadger.com")


## Configuration

All the configuration is done through the environment.

### HTTP Credentials 

These are the credentials used to authenticate the HTTP dashboard; both take a space-delimited list

* `MUNIN_USERS`
* `MUNIN_PASSWORDS`

### SMTP info for alerts

Email credentials used to send emails (like alerts)

* `SMTP_HOST`
* `SMTP_PORT`
* `SMTP_USERNAME`
* `SMTP_PASSWORD`
* `SMTP_USE_TLS`
* `SMTP_ALWAYS_SEND`
* `SMTP_MESSAGE`

### Alert target

Email addressed used for the alerts, require SMTP credentials.

* `ALERT_RECIPIENT`
* `ALERT_SENDER`

### List of the nodes to check

The port is always optional, default is 4949

* `NODES` format: `name1:ip1[:port1] name2:ip2[:port2] …`
* `SNMP_NODES` format: `name1:ip1[:port1]` …
* `SSH_NODES` format: `name1:ip1[:port1]` …

## Port

Container is listening on the port 8080

## Volumes

For a bit of persistency

* /var/log/munin   -> logs
* /var/lib/munin   -> db
* /var/run/munin   -> lock and pid files
* /var/cache/munin -> file deserved by HTTP

## How to use the image

```
docker build -t munin-server .
docker run -d \
  -p 8080:8080 \
  -v /var/log/munin:/var/log/munin \
  -v /var/lib/munin:/var/lib/munin \
  -v /var/run/munin:/var/run/munin \
  -v /var/cache/munin:/var/cache/munin \
  -e MUNIN_USERS='http-user another-user' \
  -e MUNIN_PASSWORDS='secret-password other-users-password' \
  -e SMTP_HOST=smtp.example.com \
  -e SMTP_PORT=587 \
  -e SMTP_USERNAME=smtp-username \
  -e SMTP_PASSWORD=smtp-password \
  -e SMTP_USE_TLS=false \
  -e SMTP_ALWAYS_SEND=true \
  -e SMTP_MESSAGE='[${var:group};${var:host}] -> ${var:graph_title} -> warnings: ${loop<,>:wfields  ${var:label}=${var:value}} / criticals: ${loop<,>:cfields  ${var:label}=${var:value}}' \
  -e ALERT_RECIPIENT=monitoring@example.com \
  -e ALERT_SENDER=alerts@example.com \
  -e NODES="server1:10.0.0.1 server2:10.0.0.2" \
  -e SNMP_NODES="router1:10.0.0.254:9999" \
  munin-server
```

You can now reach your munin-server on port 8080 of your host. It will display at the first run:

```
Munin has not run yet. Please try again in a few moments.
```

Every 5 minutes munin-server will interrogate its nodes and build the graphs and store the data.
That's only after the first data fetching operation that the first graphs will appear.

## Testing nodes

```
# docker exec -ti <container-id-or-name> bash
root@munin:/# apt-get install telnet
root@munin:/# su - munin --shell=/bin/bash
root@munin:/# grep address /etc/munin/munin.conf
    [...]
    address 10.147.17.19
    [...]
root@munin:/# telnet 10.147.17.19 munin
Trying 10.147.17.19...
Connected to 10.147.17.19.
Escape character is '^]'.
# munin node at <node>
list
cpu df df_inode entropy forks fw_packets if_docker0 if_err_docker0 if_err_eth0 if_err_veth2d4156a if_err_vethea78d47 if_err_zt0 if_eth0 if_veth2d4156a if_vethea78d47 if_zt0 interrupts ip_10.147.17.19 ip_10.8.82.203 ip_172.17.0.1 irqstats load memory netstat ntp_kernel_err ntp_kernel_pll_freq ntp_kernel_pll_off ntp_offset open_files open_inodes proc_pri processes swap threads uptime users vmstat
quit
Connection closed by foreign host.
```

SSH:
```
munin@munin:~$ grep ssh /etc/munin/munin.conf
    address ssh://<user>@<node>/usr/bin/nc localhost 4949
munin@munin:~$ ssh remotemonitor@boreas.zt usr/bin/nc localhost 4949
munin@munin:~$ ssh <user>@<node> /usr/bin/nc localhost 4949
# munin node at <node>
list
df df_inode cpu load memory uptime users
```
