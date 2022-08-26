#!/bin/bash
set -euxo pipefail

export NETWORK_NAME="nextcloud"

export DATA_ROOT_DIR="${DATA_ROOT_DIR:-/mnt/rootnasdata}"

export NEXTCLOUD_DATA_DIR="$DATA_ROOT_DIR/nextcloud/data"
export POSTGRES_DATA_DIR="$DATA_ROOT_DIR/nextcloud/db"

export ONLYOFFICE_DATA_DIR="$DATA_ROOT_DIR/onlyoffice/data"
export ONLYOFFICE_LOGS_DIR="$DATA_ROOT_DIR/onlyoffice/logs"

export POSTGRES_DB="nextcloud"
export POSTGRES_USER="nextcloud"
export POSTGRES_PASSWORD="nextcloud"
export POSTGRES_POD_NAME="pg-nextcloud"

mkdir -p "$NEXTCLOUD_DATA_DIR"
mkdir -p "$POSTGRES_DATA_DIR"
mkdir -p "$ONLYOFFICE_DATA_DIR"
mkdir -p "$ONLYOFFICE_LOGS_DIR"

./podman-create-network.sh
./podman-pod-create-postgres.sh
./podman-pod-create-nextcloud.sh
./podman-pod-create-onlyoffice.sh
./systemd-create-services.sh
