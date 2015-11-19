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
                        heepster/docker-elasticsearch-s3-snapshot
```

## Plugins

This image installs the `elasticsearch-head` plugin.  You'll need to add the `http.cors.enabled: true` to the Elasticsearch configuration. 

## Dockerhub

This image is automatically built by Dockerhub.  The repository is: https://hub.docker.com/r/heepster/docker-elasticsearch-s3-snapshot/

## Configuration

### Elasticsearch Config

You can pass additional elastic search config options by appending them to end of the `docker run` command:

```
-Des.node.name="TestNode"
```

### Sane Health Check

Optionally, this docker offers the ability to give you back a sane health check while restoring the snapshot.  If you query ElasticSearch's `_cluster/health` endpoint while restoring the snapshot, it will give you back something like

```
{ "status": "red",
...
}
```

The "red" is supposed to indicate that ElasticSearch isn't ready.  However, the actual HTTP response is a 200, which throws off health check services that rely on a non-200 response to infer health status.

You can turn on the sane health check feature by setting an environment variable to true:

```
SANE_HEALTH_CHECK=true
```

Then, a new endpoint will give you either a `200` or `500` depending on whether or not the snapshot restoration is complete.  That endpoint is:

```
<ip>:9400/
```

(Note that the port is different from ElasticSearch's default port.)

## TODOs

1.  If the Snapshot restoration process fails (e.g. if the snapshot doesn't exist), ElasticSearch's cluster health check will return a 'status: green' which means everything is working...Unfortunately, the sane health check feature will then relay this exactly.  If the snapshot doesn't work, then I think the right thing to do is to kill the docker.  Still need to think more about this.    
