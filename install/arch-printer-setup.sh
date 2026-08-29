#!/usr/bin/env bash
# Configure the home HP Color LaserJet CP1525N on the LAN.
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  exec sudo --preserve-env=PATH -- "$0" "$@"
fi

echo "==> Enabling CUPS"
systemctl enable --now cups.service

if lpinfo -m | grep -q 'lsb/usr/cupsfilters/pxlcolor.ppd'; then
    echo "==> Adding HP-CP1525N at 192.168.178.26"
    lpadmin \
        -p HP-CP1525N \
        -v socket://192.168.178.26:9100 \
        -m lsb/usr/cupsfilters/pxlcolor.ppd \
        -E
    lpadmin -d HP-CP1525N
    echo "Printer HP-CP1525N configured as default."
else
    echo "HP CP1525N driver is not available; skipping printer setup."
fi
