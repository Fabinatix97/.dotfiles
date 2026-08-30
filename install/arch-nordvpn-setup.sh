#!/usr/bin/env bash
# Install NordVPN.
set -euo pipefail

echo "==> Installing NordVPN"
yay -S --noconfirm nordvpn-bin
sudo usermod -aG nordvpn "$USER"

echo
echo "NordVPN installed. Reboot, then run:"
echo "  sudo systemctl enable --now nordvpnd"
echo "  nordvpn login --token <YOUR_ACCESS_TOKEN>"
