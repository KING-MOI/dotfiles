#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

install() {
  "$REPO_ROOT/install.sh" "$@" </dev/null >/dev/null
}

test_links_every_file() {
  install
  assert_link "$HOME/.zshrc" "$REPO_ROOT/zsh/.zshrc"
  assert_link "$HOME/.zshenv" "$REPO_ROOT/zsh/.zshenv"
  assert_link "$HOME/.gitconfig" "$REPO_ROOT/git/gitconfig"
  assert_link "$HOME/.config/git/ignore" "$REPO_ROOT/git/gitignore_global"
  assert_link "$HOME/.config/git/message" "$REPO_ROOT/git/gitmessage"
  assert_link "$HOME/.tmux.conf" "$REPO_ROOT/tmux/tmux.conf"
  assert_link "$HOME/.config/nvim" "$REPO_ROOT/nvim"
}

test_backs_up_existing_files() {
  echo "old zshrc" > "$HOME/.zshrc"
  BACKUP_DIR="$HOME/backup" install
  assert_link "$HOME/.zshrc" "$REPO_ROOT/zsh/.zshrc"
  assert_eq "$(cat "$HOME/backup/.zshrc")" "old zshrc"
}

test_is_idempotent() {
  install
  BACKUP_DIR="$HOME/backup" install
  assert_link "$HOME/.zshrc" "$REPO_ROOT/zsh/.zshrc"
  assert_missing "$HOME/backup"
}

test_dry_run_changes_nothing() {
  echo "keep me" > "$HOME/.zshrc"
  install --dry-run
  assert_eq "$(cat "$HOME/.zshrc")" "keep me"
  assert_missing "$HOME/.tmux.conf"
  assert_missing "$HOME/.config"
  assert_missing "$HOME/.dotfiles-backup"
}

test_uninstall_removes_only_our_links() {
  install
  ln -s /etc/hosts "$HOME/.foreign"
  install --uninstall
  assert_missing "$HOME/.zshrc"
  assert_missing "$HOME/.config/nvim"
  assert_link "$HOME/.foreign" /etc/hosts
}

test_writes_git_identity_from_env() {
  GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com" install
  assert_eq "$(cd / && git config user.email)" "test@example.com"
}

test_keeps_existing_git_identity() {
  printf '[user]\n\temail = keep@example.com\n' > "$HOME/.gitconfig.local"
  GIT_AUTHOR_NAME="x" GIT_AUTHOR_EMAIL="x@example.com" install
  assert_eq "$(cd / && git config user.email)" "keep@example.com"
}

run_test test_links_every_file
run_test test_backs_up_existing_files
run_test test_is_idempotent
run_test test_dry_run_changes_nothing
run_test test_uninstall_removes_only_our_links
run_test test_writes_git_identity_from_env
run_test test_keeps_existing_git_identity
exit $((FAILURES > 0))
