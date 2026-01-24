# dotfiles

[![ci](https://github.com/OWNER/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/dotfiles/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![shell: zsh](https://img.shields.io/badge/shell-zsh-89e051)
![editor: neovim](https://img.shields.io/badge/editor-neovim-57A143)

Personal configuration for zsh, git, tmux, neovim and Homebrew.

## Install

```sh
git clone https://github.com/OWNER/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run   # see what will change
./install.sh             # link everything
```

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before a link
replaces them. Running the script again is safe: links that are already in
place are skipped.

On a new Mac, `./install.sh --brew` also installs everything in
[`brew/Brewfile`](brew/Brewfile).
