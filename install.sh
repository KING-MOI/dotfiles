#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DRY_RUN=0

LINKS="
zsh/.zshrc .zshrc
zsh/.zshenv .zshenv
git/gitconfig .gitconfig
git/gitignore_global .config/git/ignore
git/gitmessage .config/git/message
tmux/tmux.conf .tmux.conf
nvim .config/nvim
"

usage() {
  cat <<USAGE
usage: install.sh [options]

Symlink dotfiles from $DOTFILES_DIR into \$HOME.

options:
  -n, --dry-run   print what would happen without touching anything
  -h, --help      show this help
USAGE
}

run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "  would run: $*"
  else
    "$@"
  fi
}

link_one() {
  local src="$DOTFILES_DIR/$1" dest="$HOME/$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "already linked $2"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    run mkdir -p "$BACKUP_DIR/$(dirname "$2")"
    run mv "$dest" "$BACKUP_DIR/$2"
    echo "backed up $2 to $BACKUP_DIR"
  fi
  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  echo "linked $2"
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

while read -r src dest; do
  [ -n "$src" ] || continue
  link_one "$src" "$dest"
done <<< "$LINKS"
