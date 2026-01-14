#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

test_zsh_files_parse() {
  local f
  for f in "$REPO_ROOT"/zsh/*.zsh "$REPO_ROOT"/zsh/.zshrc "$REPO_ROOT"/zsh/.zshenv; do
    zsh -n "$f" || fail "zsh syntax error in $f"
  done
}

test_zsh_starts_without_errors() {
  "$REPO_ROOT/install.sh" </dev/null >/dev/null
  local err
  err="$(cd "$HOME" && env -u ZDOTDIR DOTFILES_NO_PLUGINS=1 zsh -i -c exit 2>&1 >/dev/null)"
  assert_eq "$err" "" "interactive zsh wrote to stderr: $err"
}

test_tmux_conf_loads() {
  command -v tmux >/dev/null || { echo "    skip: tmux not installed"; return; }
  local sock="dotfiles-test-$$"
  tmux -L "$sock" -f /dev/null new-session -d \; source-file "$REPO_ROOT/tmux/tmux.conf" \
    || fail "tmux.conf failed to load"
  tmux -L "$sock" kill-server 2>/dev/null
}

test_gitconfig_parses() {
  git config -f "$REPO_ROOT/git/gitconfig" --list >/dev/null || fail "gitconfig does not parse"
  git config -f "$REPO_ROOT/git/gitconfig.local.example" --list >/dev/null \
    || fail "gitconfig.local.example does not parse"
}

test_brewfile_parses() {
  command -v ruby >/dev/null || { echo "    skip: ruby not installed"; return; }
  ruby -c "$REPO_ROOT/brew/Brewfile" >/dev/null || fail "Brewfile is not valid ruby"
}

run_test test_zsh_files_parse
run_test test_gitconfig_parses
run_test test_brewfile_parses
run_test test_tmux_conf_loads
run_test test_zsh_starts_without_errors
exit $((FAILURES > 0))
