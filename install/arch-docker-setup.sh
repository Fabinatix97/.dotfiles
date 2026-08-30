#!/usr/bin/env bash
# Install Docker Engine, Compose, and Buildx.
set -euo pipefail

echo "==> Installing Docker"
sudo pacman -S --needed --noconfirm docker docker-compose docker-buildx
sudo usermod -aG docker "$USER"

echo
echo "Docker installed. Reboot (or re-login), then run:"
echo "  sudo systemctl enable --now docker.service"
echo "  docker run --rm hello-world"
