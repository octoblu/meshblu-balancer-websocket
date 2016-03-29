#!/bin/sh

if [ -z "$SERVERS" ]; then
  echo "SERVERS not found, cowardly refusing to do anything"
  exit 1
fi

pen -f -u root -C 9000 -X -r 80 $SERVERS
