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

## What gets linked

| Source | Target |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zshenv` | `~/.zshenv` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/gitignore_global` | `~/.config/git/ignore` |
| `git/gitmessage` | `~/.config/git/message` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` |

## Machine-local settings

Things that differ between machines stay out of the repo:

- `~/.gitconfig.local` holds `user.name` and `user.email`. The installer writes
  it from `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` or asks for them. See
  [`git/gitconfig.local.example`](git/gitconfig.local.example).
- `~/.zshrc.local` is sourced last, for work-only aliases, tokens and paths.
