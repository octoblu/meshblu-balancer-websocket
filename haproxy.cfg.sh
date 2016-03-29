#!/bin/bash

cat <<EOF
global
  stats socket /tmp/haproxy.sock
  maxconn 80000

defaults
  log    global
  mode   http
  timeout client 60s            # Client and server timeout must match the longest
  timeout server 300s           # time we may wait for a response from the server.
  timeout queue  120s           # Don't queue requests too long if saturated.
  timeout connect 10s           # There's no reason to change this one.
  timeout http-request 300s     # A complete request may never take that long.
  timeout tunnel 2h
  retries         3
  option redispatch
  option httplog
  option dontlognull
  option http-server-close      # enable HTTP connection closing on the server side
  option abortonclose           # enable early dropping of aborted requests from pending queue
  option httpchk                # enable HTTP protocol to check on servers health
EOF

echo "stats auth opsworks:$PASSWORD"

cat <<EOF
  stats uri /haproxy?stats

backend meshblu-websocket
  balance roundrobin
  timeout queue 5000
  timeout server 86400000
  timeout connect 86400000
  timeout check 1s
  option forwardfor
  no option httpclose
  option http-server-close
  option forceclose
  option httpchk GET /healthcheck
EOF

for SERVER in $SERVERS; do
  echo "  server meshblu-$SERVER $SERVER check inter 10s"
done

cat <<EOF
  http-request set-header Host meshblu-websocket.octoblu.com

frontend http-in
  bind :80

  default_backend meshblu-websocket
EOF
