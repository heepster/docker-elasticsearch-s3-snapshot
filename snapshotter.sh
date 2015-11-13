#!/bin/bash

set -e

: '
This script: 

1. Waits for elasticsearch to boot up
2. Registers the specified snapshot repository with elasticsearch
3. Triggers the snapshot restoration processs

These environment variables MUST be set:

AWS_ACCESS_KEY_ID
AWS_SECRET_KEY
SNAPSHOT_ID
SNAPSHOT_BUCKET

Adapted from a script by https://github.com/yoshimotob
'

# TODO - verify environment variables are set otherwise die

HOST=localhost
PORT=9200
POLL_INTERVAL=5

log() {
    echo "[SNAPSHOTTER][INFO] $1"
}

waitForServerToStart() {
    log "Waiting for Elasticsearch to start"
    while true; do
        if curl -s "http://$HOST:$PORT/" | grep -q "\"status\" : 200"; then break; fi
        sleep $POLL_INTERVAL
    done
}

registerSnapshotRepository() {
    log "Registering snapshot repository"
    curl -s -XPUT "http://$HOST:$PORT/_snapshot/s3_root" -d "{\"type\":\"s3\", \"settings\":{\"bucket\":\"$SNAPSHOT_BUCKET\"}}"
}

triggerRestoreFromSnapshot() {
    log "Restoring replica from snapshot '$SNAPSHOT_ID'"
    curl -s -XPOST "http://$HOST:$PORT/_snapshot/s3_root/${SNAPSHOT_ID}/_restore"
}

startSnapshotter() {
    waitForServerToStart
    registerSnapshotRepository
    triggerRestoreFromSnapshot
}

startSnapshotter
