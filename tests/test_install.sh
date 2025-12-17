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

run_test test_links_every_file
exit $((FAILURES > 0))
