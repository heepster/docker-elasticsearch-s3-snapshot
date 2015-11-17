#!/bin/bash

# Adaped from:
# https://github.com/docker-library/elasticsearch/blob/master/1.7/docker-entrypoint.sh

ES_PORT=9200
ES_HEALTH_PATH="_cluster/health"
KOMOREBI_PORT=9400
KOMOREBI_COMMAND="curl -s localhost:$ES_PORT/$ES_HEALTH_PATH | grep -q GOOD"

set -e

# Start Snapshot process
./snapshotter.sh &

# Starts 'sane health check' process
# The sane health checker translates $KOMOREBI_COMMAND's exit code
# into an HTTP 200 or 500, and starts an HTTP server via netcat
# The reason to use this is because ElasticSearch's health check
# returns a 200 regardless of cluster health
if [ ! -z "$SANE_HEALTH_CHECK" ]; then
    echo "Loading Sane Health Checker"
    curl -s 'https://raw.githubusercontent.com/heepster/komorebi/master/komorebi' | COMMAND=$KOMOREBI_COMMAND PORT=$KOMOREBI_PORT bash &
fi

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
    # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
    exec gosu elasticsearch "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
