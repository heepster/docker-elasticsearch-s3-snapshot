# Docker ElasticSearch S3 Snapshot
This is a docker image that has ElasticSearch load a specified snapshot from S3. 

## Usage

It requires these environmnent variables be set:

1. `AWS_ACCESS_KEY_ID` - Your S3 access key
2. `AWS_SECRET_KEY` - Your S3 secret key
3. `SNAPSHOT_BUCKET` - The S3 bucket that the snapshot is in
4. `SNAPSHOT_ID` - The snapshot you wish to restore from

Examples:
```
docker run -p 9200:9200 -e "AWS_ACCESS_KEY_ID=1234" \
                        -e "AWS_SECRET_KEY=1234" \
                        -e "SNAPSHOT_BUCKET=my_snapshots" \
                        -e "SNAPSHOT_ID=my_snapshot" \
                        -e "CLUSTER_NAME=my-cluster" \
                        heepster/docker-elasticsearch-s3-snapshot
```

## Plugins

This image installs the `elasticsearch-head` plugin.  You'll need to add the `http.cors.enabled: true` to the Elasticsearch configuration. 

## Dockerhub

This image is automatically built by Dockerhub.  The repository is: https://hub.docker.com/r/heepster/docker-elasticsearch-s3-snapshot/
