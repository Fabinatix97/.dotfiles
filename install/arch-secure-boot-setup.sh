#!/usr/bin/env bash
# Set up sbctl Secure Boot keys and sign the current UKI/EFI binaries.
# Follows https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Signing
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  exec sudo --preserve-env=PATH -- "$0" "$@"
fi

echo "==> Installing sbctl"
pacman -S --needed --noconfirm sbctl

echo "==> Creating Secure Boot keys"
sbctl create-keys

echo "==> Signing unsigned EFI binaries"
# See https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Signing
sbctl verify | sed -E 's|^.* (/.+) is not signed$|sbctl sign -s "\1"|e' || true

echo "==> Verifying signatures"
sbctl verify

echo "==> Enrolling keys (including Microsoft)"
sbctl enroll-keys --microsoft

echo
echo "Secure Boot setup finished. Reboot and confirm with: sbctl status"
