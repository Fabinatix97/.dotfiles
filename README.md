# dotfiles

This is my public dotfiles repository with configurations for Hyprland, Kitty
and more.

## Setup

This repo is optimized for use with [GNU stow](https://www.gnu.org/software/stow/):

```bash
cd dotfiles

# Stow a single config
stow hyprland

# Stow multiple configs
stow hyprland kitty starship
```

## Personal Settings

Private configurations are kept in a separate private repository called
`dotfiles-personal`, which is included here as a Git submodule. After cloning
this repository, initialize the submodule with:

```bash
cd dotfiles
git submodule update --init private
```

You can update the submodule like this:

```bash
cd dotfiles
git submodule update --remote private
git add private
git commit -m "Update private submodule"
git push
```

> [!note]
> The dotfiles repo stores the exact commit hash of dotfiles-personal in its Git
> history. If you make changes to the `main` branch of dotfiles-personal, they
> are not automatically reflected here. You’ll need to manually update the
> submodule to get the latest state of the main branch.

## VS Code Extensions

To install all my frequently used VS Code extensions at once, run the following
command:

```bash
cd dotfiles
while read ext; do
  code --install-extension "$ext" --force
done < vscode.extensions
```

To export the current extensions list, run the following command:

```bash
cd dotfiles
code --list-extensions > vscode.extensions
```
