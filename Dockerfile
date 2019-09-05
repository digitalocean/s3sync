FROM docker.io/mesosphere/aws-cli:1.14.5
RUN apk add --no-cache bash inotify-tools dumb-init
ENV S3_PATH S3_ENDPOINT LOCAL_DIR
ADD sync.sh /app/sync.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/app/sync.sh"]
