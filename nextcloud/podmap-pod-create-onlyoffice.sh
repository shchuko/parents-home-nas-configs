#!/bin/bash
set -euxo pipefail

: "$NETWORK_NAME"

ONLYOFFICE_POD_NAME="${ONLYOFFICE_POD_NAME:-onlyoffice}"

ONLYOFFICE_VERSION="${ONLYOFFICE_VERSION:-7.1}"
: "$ONLYOFFICE_DATA_DIR"
: "$ONLYOFFICE_LOGS_DIR"

ONLYOFFICE_EXPOSED_PORT=8090

if ! podman pod exists "$ONLYOFFICE_POD_NAME"; then
  podman pod create --name "$ONLYOFFICE_POD_NAME" --infra --publish "$ONLYOFFICE_EXPOSED_PORT":80 --network "$NETWORK_NAME"
  echo "Pod '$ONLYOFFICE_POD_NAME' creation successful"
else
  echo "Network '$ONLYOFFICE_POD_NAME' already exists, skipped"
fi

ONLYOFFICE_CONTAINER_NAME="$ONLYOFFICE_POD_NAME-app"
if ! podman container exists "$ONLYOFFICE_CONTAINER_NAME"; then
  podman create --pod "$ONLYOFFICE_POD_NAME" --name "$ONLYOFFICE_CONTAINER_NAME" \
    -v "$ONLYOFFICE_DATA_DIR":/var/www/onlyoffice/Data:Z \
    -v "$ONLYOFFICE_LOGS_DIR":/var/log/onlyoffice:Z \
    "docker.io/onlyoffice/documentserver:$ONLYOFFICE_VERSION"
  echo "Container '$ONLYOFFICE_CONTAINER_NAME' creation successful"
else
  echo "Container '$ONLYOFFICE_CONTAINER_NAME' already exists, skipped"
fi
