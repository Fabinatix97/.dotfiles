#!/usr/bin/env bash
# Install OneDrive (abraunegg client).
set -euo pipefail

echo "==> Installing OneDrive"
yay -S --noconfirm onedrive-abraunegg
systemctl --user daemon-reload

echo
echo "OneDrive installed. After reboot, run:"
echo "  onedrive --sync --resync"
echo "  systemctl --user enable --now onedrive.service"
