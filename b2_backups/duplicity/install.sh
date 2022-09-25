#!/bin/bash
set -euxo pipefail

set +x
: "$B2_KEY_ID"
: "$B2_APPLICATION_KEY"
set -x

gpg --import key.pub
pip3 install boto3

mkdir -p "$HOME/.config/systemd/user"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/config/duplicity"

envsubst < "duplicity-settings.env.template" > "duplicity-settings.env"

install -Dm700 "duplicity-backup.sh" "$HOME/.local/bin/"
install -Dm700 "duplicity-settings.env" "$HOME/.local/config/duplicity/"

install -Dm644 "systemd/duplicity-backup.service" "$HOME/.config/systemd/user/"
install -Dm644 "systemd/duplicity-backup.timer" "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable --now duplicity-backup.timer
