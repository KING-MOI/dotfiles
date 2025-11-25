#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LINKS="
zsh/.zshrc .zshrc
zsh/.zshenv .zshenv
git/gitconfig .gitconfig
git/gitignore_global .config/git/ignore
git/gitmessage .config/git/message
tmux/tmux.conf .tmux.conf
nvim .config/nvim
"

link_one() {
  local src="$DOTFILES_DIR/$1" dest="$HOME/$2"
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked $2"
}

while read -r src dest; do
  [ -n "$src" ] || continue
  link_one "$src" "$dest"
done <<< "$LINKS"
