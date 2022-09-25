#!/bin/bash
set -euo pipefail

source "$HOME/.local/config/duplicity/duplicity-settings.sh"

: "$GPG_KEY_ID"

: "$BACKUP_ROOT"

: "$B2_KEY_ID"
: "$B2_APPLICATION_KEY"
: "$B2_BUCKET"
: "$S3_ENDPOINT_URL"

export AWS_ACCESS_KEY_ID="${B2_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${B2_APPLICATION_KEY}"
S3_URL="boto3+s3://${B2_BUCKET}"

backup() {
    duplicity \
        --encrypt-key "${GPG_KEY_ID}" \
        --use-agent \
        --asynchronous-upload \
        --verbosity 8 \
        --s3-endpoint-url "${S3_ENDPOINT_URL}" \
        "${BACKUP_ROOT}" \
        "${S3_URL}"

    duplicity \
        cleanup \
        --use-agent \
        --force \
        --s3-endpoint-url "${S3_ENDPOINT_URL}" \
        "${S3_URL}"
}

list() {
    duplicity \
        list-current-files \
        --use-agent \
        --s3-endpoint-url "${S3_ENDPOINT_URL}" \
        "${S3_URL}"
}

verify() {
    duplicity \
        verify \
        --use-agent \
        --compare-data \
        --file-to-restore "$1" \
        --s3-endpoint-url "${S3_ENDPOINT_URL}" \
        "${S3_URL}" \
        "${BACKUP_ROOT}/$1"
}

restore-all() {
    duplicity \
        --use-agent \
        --s3-endpoint-url "${S3_ENDPOINT_URL}" \
        "${S3_URL}" \
        "$1"
}

"$@"
