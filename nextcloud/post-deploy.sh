#!/bin/bash
set -euxo pipefail

ONLYOFFICE_ADDRESS="${ONLYOFFICE_ADDRESS:-http://localparentsnas.net:8090/}"

# Complete NextCloud installation
podman exec -u www-data nextcloud-app php occ --no-warnings maintenance:install --admin-user="admin" --admin-pass="admin" --database="pgsql" --database-host="127.0.0.1" --database-name="nextcloud" --database-user="nextcloud" --database-pass="nextcloud"

# Home internal network - all domains are trusted
podman exec -u www-data nextcloud-app php occ --no-warnings config:system:set trusted_domains "2" --value="*"

# Setup onlyoffice
podman exec -u www-data nextcloud-app php occ --no-warnings app:install onlyoffice
podman exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="$ONLYOFFICE_ADDRESS"
podman exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://onlyoffice/"
podman exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nextcloud/"

# Enable previews - required installed ffmpeg
podman exec -u www-data nextcloud-app php occ --no-warnings config:system:set enable_previews --value=true
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 0 --value="OC\\Preview\\Image"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 1 --value="OC\\Preview\\Movie"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 2 --value="OC\\Preview\\TXT"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 3 --value="OC\\Preview\\MP3"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 4 --value="OC\\Preview\\MKV"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 5 --value="OC\\Preview\\MP4"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 6 --value="OC\\Preview\\AVI"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 7 --value="OC\\Preview\\MarkDown"
podman exec -u www-data nextcloud-app php occ config:system:set enabledPreviewProviders 8 --value="OC\\Preview\\PDF"

