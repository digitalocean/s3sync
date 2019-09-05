# s3sync

This app watches a local directory and synchronizes it's contents to an
s3-compatible remote.

## Usage

```
# download pulls resources from the remote to the local dir once and exits
docker run --rm -it \
        -e AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY \
        -e S3_PATH=s3://mybucket/path/to/dir \
        -e LOCAL_DIR=/data \
        docker.io/digitalocean/s3sync \
        download
```

```
# upload watches for changes in the LOCAL_DIR and runs s3 sync when it detects changes
docker run --rm -it \
        -e AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY \
        -e S3_PATH=s3://mybucket/path/to/dir \
        -e LOCAL_DIR=/data \
        docker.io/digitalocean/s3sync \
        upload
```
