#!/bin/bash
set -euxo pipefail

: "$NETWORK_NAME"

NEXTCLOUD_POD_NAME="${NEXTCLOUD_POD_NAME:-nextcloud}"

: "$POSTGRES_USER"
: "$POSTGRES_PASSWORD"
: "$POSTGRES_POD_NAME"

REDIS_VERSION="${REDIS_VERSION:-7.0.4-alpine3.16}"

NEXTCLOUD_VERSION="${NEXTCLOUD_VERSION:-24.0.4-apache-ffmpeg}"
: "$NEXTCLOUD_DATA_DIR"

NEXTCLOUD_EXPOSED_PORT=8080

if ! podman pod exists "$NEXTCLOUD_POD_NAME"; then
  podman pod create --name "$NEXTCLOUD_POD_NAME" --infra --publish "$NEXTCLOUD_EXPOSED_PORT":80 --network "$NETWORK_NAME"
  echo "Pod '$NEXTCLOUD_POD_NAME' creation successful"
else
  echo "Network '$NEXTCLOUD_POD_NAME' already exists, skipped"
fi

REDIS_CONTAINER_NAME="$NEXTCLOUD_POD_NAME-redis"
if ! podman container exists "$REDIS_CONTAINER_NAME"; then
  podman create --pod "$NEXTCLOUD_POD_NAME" --name "$REDIS_CONTAINER_NAME" \
    "docker.io/library/redis:$REDIS_VERSION"
  echo "Container '$REDIS_CONTAINER_NAME' creation successful"
else
  echo "Container '$REDIS_CONTAINER_NAME' already exists, skipped"
fi

CRON_CONTAINER_NAME="$NEXTCLOUD_POD_NAME-cron"
if ! podman container exists "$CRON_CONTAINER_NAME"; then
  podman create --pod "$NEXTCLOUD_POD_NAME" --name "$CRON_CONTAINER_NAME" \
    -v "$NEXTCLOUD_DATA_DIR:/var/www/html":z \
    "docker.io/shchuko/nextcloud-ffmpeg:$NEXTCLOUD_VERSION" \
    "/cron.sh"
  echo "Container '$CRON_CONTAINER_NAME' creation successful"
else
  echo "Container '$CRON_CONTAINER_NAME' already exists, skipped"
fi

APP_CONTAINER_NAME="$NEXTCLOUD_POD_NAME-app"
if ! podman container exists "$APP_CONTAINER_NAME"; then
  podman create --pod "$NEXTCLOUD_POD_NAME" --name "$APP_CONTAINER_NAME" \
    -e POSTGRES_USER="$POSTGRES_USER" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
    -e POSTGRES_HOST="$POSTGRES_POD_NAME" \
    -e REDIS_HOST="127.0.0.1" \
    -v "$NEXTCLOUD_DATA_DIR:/var/www/html":z \
    "docker.io/shchuko/nextcloud-ffmpeg:$NEXTCLOUD_VERSION"
  echo "Container '$APP_CONTAINER_NAME' creation successful"
else
  echo "Container '$APP_CONTAINER_NAME' already exists, skipped"
fi
