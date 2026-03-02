#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.dotfiles-backup}"
BACKUP_DIR="${BACKUP_DIR:-$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)}"
DRY_RUN=0
MODE=install
WITH_BREW=0

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
  -b, --brew       also run brew bundle against brew/Brewfile
  -u, --uninstall  remove links that point into this repo and restore
                   the newest backup of each file, if any
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

setup_git_identity() {
  local file="$HOME/.gitconfig.local"
  local name="${GIT_AUTHOR_NAME:-}" email="${GIT_AUTHOR_EMAIL:-}"
  if [ -f "$file" ]; then
    ok "found $file"
    return
  fi
  if [ -t 0 ]; then
    [ -n "$name" ] || read -rp "git user.name: " name
    [ -n "$email" ] || read -rp "git user.email: " email
  fi
  if [ -z "$name" ] || [ -z "$email" ]; then
    warn "no git identity given, skipping $file"
    return
  fi
  if [ "$DRY_RUN" = 1 ]; then
    echo "  would write $file"
    return
  fi
  printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$file"
  ok "wrote $file"
}

brew_bundle() {
  command -v brew >/dev/null 2>&1 || die "brew not found, install it from https://brew.sh"
  run brew bundle --file "$DOTFILES_DIR/brew/Brewfile"
}

unlink_one() {
  local src="$DOTFILES_DIR/$1" dest="$HOME/$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    run rm "$dest"
    [ "$DRY_RUN" = 1 ] || ok "removed $2"
    restore_backup "$2"
  fi
}

restore_backup() {
  local dir backup=""
  for dir in "$BACKUP_ROOT"/*/; do
    if [ -e "$dir$1" ] || [ -L "$dir$1" ]; then
      backup="$dir$1"
    fi
  done
  [ -n "$backup" ] || return 0
  run mv "$backup" "$HOME/$1"
  [ "$DRY_RUN" = 1 ] || ok "restored $1 from ${backup%/"$1"}"
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    -b|--brew) WITH_BREW=1 ;;
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

if [ "$WITH_BREW" = 1 ]; then
  info "installing packages from Brewfile"
  brew_bundle
fi

info "linking dotfiles from $DOTFILES_DIR"
each_link link_one

info "git identity"
setup_git_identity
