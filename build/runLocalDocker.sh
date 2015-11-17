#!/bin/bash

set -e

source build/conf.sh

docker run --dns 8.8.8.8 -p 9200:9200 -p 9400:9400 \
       -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
       -e "AWS_SECRET_KEY=$AWS_SECRET_KEY" \
       -e "SNAPSHOT_BUCKET=$SNAPSHOT_BUCKET" \
       -e "SNAPSHOT_ID=$SNAPSHOT_ID" \
       -e "SANE_HEALTH_CHECK=true" \
       $LOCAL_IMAGE_NAME \
            -Des.discovery.zen.ping.multicast.enabled=false \
            -Des.http.max_content_length=1000mb \
            -Des.bootstrap.mlockall=true \
            -Des.http.cors.enabled=true \
            -Des.http.cors.allow-origin='*' \
            -Des.index.number_of_replicas=0 \
            -Des.index.number_of_shards=1
