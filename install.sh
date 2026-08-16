#!/usr/bin/env bash
set -euo pipefail

sudo -v
sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
  age \
  base-devel \
  bat \
  brightnessctl \
  btop \
  chromium \
  cliphist \
  curl \
  fastfetch \
  fd \
  fzf \
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
  satty \
  starship \
  stow \
  swaync \
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
makepkg -si --needed
cd "$HOME"
rm -rf "$HOME/yay"

# Setting up ssh
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
cd "$HOME/.ssh"
cp -a "$HOME/dotfiles/ssh/." "$HOME/.ssh"
chmod 600 "$HOME/.ssh/known_hosts"
echo "Insert your YubiKey and touch it when prompted..."
ssh-keygen -K
echo "Testing GitHub SSH authentication..."
ssh -i ~/.ssh/id_ed25519_sk_rk_personal -T git@github.com || true
rm -rf "$HOME/dotfiles"

# Clone and stow dotfiles
git clone -b arch git@github.com:Fabinatix97/dotfiles.git "$HOME/dotfiles/"
cd "$HOME/dotfiles/"
git submodule update --init private
stow btop fastfetch hypr kitty nvim screenshot starship tmux waybar wofi
git clone -b arch git@github.com:Fabinatix97/dotfiles-personal.git "$HOME/dotfiles-personal/"
cd "$HOME/dotfiles-personal/"
stow bashrc git fonts onedrive
fc-cache -fv

# Update .bashrc
cat >> "$HOME/.bashrc" <<'EOF'
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
EOF
source "$HOME/.bashrc"

# Enable hyprpokitagent
systemctl --user enable hyprpolkitagent.service

# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
nvm install 26

npm install -g markdownlint-cli2 markdown-toc prettier tree-sitter-cli

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Dark mode as default
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Install sdkman for managing jdks and sdks
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 26-tem
sdk install maven

# Install nordvpn
yay -S --noconfirm nordvpn-bin
sudo usermod -aG nordvpn $USER

# Installing onedrive
yay -S --noconfirm onedrive-abraunegg
systemctl --user daemon-reload
systemctl --user enable --now onedrive.service

echo
echo "========================================"
echo "Installation complete."
echo "Please reboot, then run:"
echo
echo "  systemctl enable --now nordvpn"
echo "  nordvpn login --token <YOUR_ACCESS_TOKEN>"
echo "========================================"
