#!/usr/bin/env bash
# Configure proprietary NVIDIA 580xx for Wayland/Hyprland on Arch.
# Follows https://wiki.archlinux.org/title/NVIDIA
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  exec sudo --preserve-env=PATH -- "$0" "$@"
fi

KERNEL_RELEASE="$(uname -r)"
echo "==> Kernel: ${KERNEL_RELEASE}"
echo "==> GPU: GeForce GTX 1060 (Pascal) -> nvidia-580xx"

echo "==> Installing linux-headers (required to build nvidia-580xx-dkms)"
pacman -S --needed --noconfirm linux-headers

echo "==> Ensuring NVIDIA DKMS modules are built"
if ! dkms status | grep -q 'nvidia/580.178.04.*installed'; then
  dkms autoinstall -k "${KERNEL_RELEASE}"
fi
dkms status

if ! modinfo nvidia >/dev/null 2>&1; then
  echo "ERROR: nvidia kernel module was not built. Check DKMS output above." >&2
  exit 1
fi

NVIDIA_CONF=/etc/modprobe.d/nvidia.conf
echo "==> Enabling DRM KMS (modeset + fbdev) in ${NVIDIA_CONF}"
# nvidia-580xx-utils blacklists nouveau but does not ship modeset=1.
# fbdev is required for Wayland on Linux 6.11+ (this system is 7.1).
cat > "${NVIDIA_CONF}" <<'EOF'
# DRM kernel mode setting for Wayland compositors.
# https://wiki.archlinux.org/title/NVIDIA#DRM_kernel_mode_setting
# https://wiki.archlinux.org/title/NVIDIA#Wayland_configuration
options nvidia_drm modeset=1 fbdev=1
EOF

echo "==> Early-loading NVIDIA modules and dropping the kms hook in /etc/mkinitcpio.conf"
if grep -q '^MODULES=()' /etc/mkinitcpio.conf; then
  sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
fi
# Remove only the live HOOKS entry; commented examples stay untouched.
if grep -q '^HOOKS=.* kms ' /etc/mkinitcpio.conf; then
  sed -i '/^HOOKS=/ s/ kms / /' /etc/mkinitcpio.conf
fi
grep -E '^(MODULES|HOOKS)=' /etc/mkinitcpio.conf

echo "==> Regenerating UKI/initramfs"
mkinitcpio -P

echo
echo "Setup finished. Reboot so the NVIDIA driver can replace nouveau."
echo "After reboot, verify:"
echo "  lspci -k -d ::03xx          # Kernel driver in use: nvidia"
echo "  cat /sys/module/nvidia_drm/parameters/modeset   # Y"
echo "  cat /sys/module/nvidia_drm/parameters/fbdev     # Y"
echo "  nvidia-smi"
