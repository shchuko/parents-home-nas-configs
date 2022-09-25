#!/bin/bash
set -euxo pipefail

set +x
: "$B2_KEY_ID"
: "$B2_APPLICATION_KEY"
set -x

gpg --import key.pub

mkdir -p "$HOME/.config/systemd/user"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/config/duplicity"

envsubst < "duplicity-settings.sh.template" > "duplicity-settings.sh"

install -Dm700 "duplicity-backup.sh" "$HOME/.local/bin/"
install -Dm700 "duplicity-settings.sh" "$HOME/.local/config/duplicity/"

install -Dm644 "systemd/duplicity-backup.service" "$HOME/.config/systemd/user/"
install -Dm644 "systemd/duplicity-backup.timer" "$HOME/.config/systemd/user/"
systemctl --user enable --now duplicity-backup.timer
