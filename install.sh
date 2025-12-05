#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DRY_RUN=0
MODE=install

LINKS="
zsh/.zshrc .zshrc
zsh/.zshenv .zshenv
git/gitconfig .gitconfig
git/gitignore_global .config/git/ignore
git/gitmessage .config/git/message
tmux/tmux.conf .tmux.conf
nvim .config/nvim
"

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD=$'\033[1m' GREEN=$'\033[32m' YELLOW=$'\033[33m' RED=$'\033[31m' RESET=$'\033[0m'
else
  BOLD="" GREEN="" YELLOW="" RED="" RESET=""
fi

info() { printf '%s==>%s %s\n' "$BOLD" "$RESET" "$*"; }
ok() { printf '%s  ok%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%swarn%s %s\n' "$YELLOW" "$RESET" "$*"; }
die() { printf '%s err%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
  cat <<USAGE
usage: install.sh [options]

Symlink dotfiles from $DOTFILES_DIR into \$HOME.

options:
  -u, --uninstall  remove links that point into this repo
  -n, --dry-run    print what would happen without touching anything
  -h, --help       show this help
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
    ok "already linked $2"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    run mkdir -p "$BACKUP_DIR/$(dirname "$2")"
    run mv "$dest" "$BACKUP_DIR/$2"
    [ "$DRY_RUN" = 1 ] || warn "backed up $2 to $BACKUP_DIR"
  fi
  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  [ "$DRY_RUN" = 1 ] || ok "linked $2"
}

unlink_one() {
  local src="$DOTFILES_DIR/$1" dest="$HOME/$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    run rm "$dest"
    [ "$DRY_RUN" = 1 ] || ok "removed $2"
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    -u|--uninstall) MODE=uninstall ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown option: $1" ;;
  esac
  shift
done

each_link() {
  local src dest
  while read -r src dest; do
    [ -n "$src" ] || continue
    "$1" "$src" "$dest"
  done <<< "$LINKS"
}

if [ "$MODE" = uninstall ]; then
  info "removing dotfile links"
  each_link unlink_one
  exit 0
fi

info "linking dotfiles from $DOTFILES_DIR"
each_link link_one
