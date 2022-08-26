#!/bin/bash
set -euxo pipefail

# If required
#sudo apt install openjdk-18-jre-headless

# Don't forget to change telegram.api.key property value
mkdir -p "$HOME/.config/tg-shell-bot"
cp "config.property" "$HOME/.config/tg-shell-bot/"

mkdir -p "$HOME/.jar"
wget "https://github.com/shchuko/tg-shell-bot/releases/download/1.0/tg-shell-bot-fat-1.0.jar"
mv "tg-shell-bot-fat-1.0.jar" "$HOME/.jar/"

mkdir -p "$HOME/.config/systemd/user"
cp "tg-shell-bot.service" "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable tg-shell-bot.service
systemctl --user start tg-shell-bot.service

loginctl enable-linger "$USER"
