#!/bin/bash
set -euxo pipefail

: "$NETWORK_NAME"

if ! podman network exists "$NETWORK_NAME"; then
  podman network create "$NETWORK_NAME"
  echo "Network '$NETWORK_NAME' creation successful"
else
  echo "Network '$NETWORK_NAME' already exists, skipped"
fi
