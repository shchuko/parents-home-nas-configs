#!/bin/bash
set -euxo pipefail

: "$NETWORK_NAME"
: "$POSTGRES_POD_NAME"

POSTGRES_VERSION="${POSTGRES_VERSION:-14.5-alpine3.16}"
: "$POSTGRES_DATA_DIR"
: "$POSTGRES_DB"
: "$POSTGRES_USER"
: "$POSTGRES_PASSWORD"

if ! podman pod exists "$POSTGRES_POD_NAME"; then
  podman pod create --name "$POSTGRES_POD_NAME" --infra --network "$NETWORK_NAME" --userns=keep-id
  echo "Pod '$POSTGRES_POD_NAME' creation successful"
else
  echo "Network '$POSTGRES_POD_NAME' already exists, skipped"
fi

# https://github.com/docker-library/postgres/pull/253
DB_CONTAINER_NAME="$POSTGRES_POD_NAME-db"
if ! podman container exists "$DB_CONTAINER_NAME"; then
  podman create --name "$DB_CONTAINER_NAME" \
    -e POSTGRES_DB="$POSTGRES_DB" \
    -e POSTGRES_USER="$POSTGRES_USER" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
    -u "$(id -u):$(id -g)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v "$POSTGRES_DATA_DIR":/var/lib/postgresql/data \
    "docker.io/library/postgres:$POSTGRES_VERSION"
  echo "Container '$DB_CONTAINER_NAME' creation successful"
else
  echo "Container '$DB_CONTAINER_NAME' already exists, skipped"
fi
