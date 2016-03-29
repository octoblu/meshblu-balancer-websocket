#!/bin/sh

assert_servers(){
  local servers="$1"

  if [ -z "$servers" ]; then
    echo "SERVERS not found, cowardly refusing to do anything"
    exit 1
  fi
}

assert_password() {
  local password="$1"

  if [ -z "$password" ]; then
    echo "PASSWORD not found, cowardly refusing to do anything"
    exit 1
  fi
}

run_haproxy() {
  haproxy -f /usr/local/etc/haproxy/haproxy.cfg &
  child=$!
  echo "Waiting for child process: $child"
  wait "$child"
}

write_haproxy() {
  local servers="$1"
  local password="$2"

  env \
    SERVERS="${servers}" \
    PASSWORD="${password}" \
    ./haproxy.cfg.sh > /usr/local/etc/haproxy/haproxy.cfg
}

main(){
  local servers="${SERVERS}"
  local password="${PASSWORD}"
  assert_servers "${servers}"
  assert_password "${password}"

  write_haproxy "${servers}" "${password}"
  run_haproxy
}

main $@
