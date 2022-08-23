#!/bin/bash
set -euxo pipefail

mkdir -p "$HOME/.config/systemd/user"
cd "$HOME/.config/systemd/user"
podman generate systemd --files --name "nextcloud"
podman generate systemd --files --name "onlyoffice"

systemctl --user daemon-reload

systemctl --user enable pod-onlyoffice.service
systemctl --user enable pod-nextcloud.service

systemctl --user start pod-onlyoffice.service
systemctl --user start pod-nextcloud.service

cd -