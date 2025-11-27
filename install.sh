#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"

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
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$2")"
    mv "$dest" "$BACKUP_DIR/$2"
    echo "backed up $2 to $BACKUP_DIR"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked $2"
}

while read -r src dest; do
  [ -n "$src" ] || continue
  link_one "$src" "$dest"
done <<< "$LINKS"
