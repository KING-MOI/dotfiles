#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

test_zsh_files_parse() {
  local f
  for f in "$REPO_ROOT"/zsh/*.zsh "$REPO_ROOT"/zsh/.zshrc "$REPO_ROOT"/zsh/.zshenv; do
    zsh -n "$f" || fail "zsh syntax error in $f"
  done
}

run_test test_zsh_files_parse
exit $((FAILURES > 0))
