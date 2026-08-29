#!/usr/bin/env bash
# Generic Arch Linux bootstrap shared by every machine.
# Hardware- and host-specific steps live in sibling scripts:
#   arch-secure-boot-setup.sh
#   arch-nvidia-setup.sh
#   arch-printer-setup.sh
set -euo pipefail

sudo -v
sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
  age \
  base-devel \
  bat \
  bc \
  brightnessctl \
  btop \
  chromium \
  cliphist \
  cups \
  cups-filters \
  curl \
  fastfetch \
  fd \
  fzf \
  ghostscript \
  gimp \
  git \
  github-cli \
  go \
  helm \
  hypridle \
  hyprland \
  hyprlock \
  hyprpaper \
  hyprpicker \
  hyprpolkitagent \
  jq \
  keepassxc \
  kitty \
  lazygit \
  libfido2 \
  make \
  man-db \
  man-pages \
  nautilus \
  neovim \
  noto-fonts \
  noto-fonts-emoji \
  obsidian \
  python \
  python-pip \
  ripgrep \
  sane \
  satty \
  starship \
  stow \
  swaync \
  thunderbird \
  tmux \
  tree \
  unzip \
  waybar \
  wf-recorder \
  wget \
  wofi \
  wtype \
  xdg-desktop-portal-hyprland \
  zip

# Build yay for AUR access
git clone https://aur.archlinux.org/yay.git "$HOME/yay"
cd "$HOME/yay"
makepkg -si --needed --noconfirm
cd "$HOME"
rm -rf "$HOME/yay"

# Setting up ssh with yubikey
#mkdir -p "$HOME/.ssh"
#chmod 700 "$HOME/.ssh"
#cd "$HOME/.ssh"
#cp -a "$HOME/.dotfiles/ssh/." "$HOME/.ssh"
#chmod 600 "$HOME/.ssh/known_hosts"
#echo "Insert your YubiKey and touch it when prompted..."
#ssh-keygen -K
#echo "Testing GitHub SSH authentication..."
#ssh -i ~/.ssh/id_ed25519_sk_rk_personal -T git@github.com || true
#rm -rf "$HOME/.dotfiles"

# Setting up SSH
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
cd "$HOME/.ssh"
cp -a "$HOME/.dotfiles/ssh/." "$HOME/.ssh"
echo "Decrypting private SSH key..."
for attempt in 1 2 3; do
  if age -d id_ed25519.age > id_ed25519; then
    break
  fi
  rm -f id_ed25519
  if [[ $attempt -eq 3 ]]; then
    echo "Failed to decrypt SSH key after 3 attempts." >&2
    exit 1
  fi
  echo "Wrong passphrase (attempt $attempt/3). Try again..."
done
chmod 600 "$HOME/.ssh/known_hosts"
chmod 600 "$HOME/.ssh/id_ed25519"
rm id_ed25519.age
echo "Testing GitHub SSH authentication..."
ssh -i ~/.ssh/id_ed25519 -T git@github.com || true
rm -rf "$HOME/.dotfiles"

# Clone and stow dotfiles
git clone -b arch git@github.com:Fabinatix97/.dotfiles.git "$HOME/.dotfiles/"
cd "$HOME/.dotfiles/"
git submodule update --init private
stow btop fastfetch hypr kitty nvim screenshot starship tmux waybar wofi

# Chromium defaults before the first launch. Chromium rewrites Preferences
# afterwards, so this is a one-shot copy rather than a stow package.
mkdir -p "$HOME/.config/chromium/Default"
if [[ ! -f "$HOME/.config/chromium-flags.conf" ]]; then
  cp "$HOME/.dotfiles/install/chromium/chromium-flags.conf" "$HOME/.config/chromium-flags.conf"
fi
if [[ ! -f "$HOME/.config/chromium/Default/Preferences" ]]; then
  cp "$HOME/.dotfiles/install/chromium/initial-preferences.json" \
    "$HOME/.config/chromium/Default/Preferences"
fi
git clone -b arch git@github.com:Fabinatix97/.dotfiles-personal.git "$HOME/.dotfiles-personal/"
cd "$HOME/.dotfiles-personal/"
rm -f "$HOME/.bashrc" "$HOME/.bash_profile"
stow bashrc git fonts onedrive
fc-cache -fv
source "$HOME/.bashrc"

# Enable hyprpokitagent
systemctl --user enable hyprpolkitagent.service

# Install node version manager (PROFILE=/dev/null: do not append to the stowed .bashrc)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | PROFILE=/dev/null bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 26

npm install -g markdownlint-cli2 markdown-toc prettier tree-sitter-cli

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Dark mode as default
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Install sdkman for managing jdks and sdks (rcupdate=false: do not append to the stowed .bashrc)
bash -c '
  curl -s "https://get.sdkman.io?ci=true&rcupdate=false" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java 26-tem
  sdk install maven
'

# Install nordvpn
yay -S --noconfirm nordvpn-bin
sudo usermod -aG nordvpn $USER

# Installing onedrive
yay -S --noconfirm onedrive-abraunegg
systemctl --user daemon-reload

# Installing other AUR packages
yay -S --noconfirm cursor-bin

# Other
mkdir -p "$HOME/projects/"

echo
echo "========================================"
echo "Installation complete."
echo "Please reboot, then run:"
echo
echo "  onedrive --sync --resync"
echo "  systemctl --user enable --now onedrive.service"
echo "  sudo systemctl enable --now nordvpnd"
echo "  nordvpn login --token <YOUR_ACCESS_TOKEN>"
echo
echo "Machine-specific setup (only if needed):"
echo
echo "  ~/.dotfiles/install/arch-secure-boot-setup.sh"
echo "  ~/.dotfiles/install/arch-nvidia-setup.sh"
echo "  ~/.dotfiles/install/arch-printer-setup.sh"
echo "========================================"
