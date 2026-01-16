#!/usr/bin/env bash

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT
FAILURES=0

fail() {
  echo "    FAIL: $*"
  FAILURES=$((FAILURES + 1))
}

assert_eq() {
  [ "$1" = "$2" ] || fail "${3:-expected [$2], got [$1]}"
}

assert_link() {
  [ -L "$1" ] || { fail "$1 is not a symlink"; return; }
  assert_eq "$(readlink "$1")" "$2" "$1 points to $(readlink "$1"), want $2"
}

assert_file() {
  [ -f "$1" ] || fail "missing file $1"
}

assert_missing() {
  [ ! -e "$1" ] && [ ! -L "$1" ] || fail "$1 should not exist"
}

new_home() {
  TEST_HOME="$(mktemp -d)"
  export HOME="$TEST_HOME"
}

cleanup_home() {
  rm -rf "$TEST_HOME"
}

run_test() {
  echo "  $1"
  new_home
  "$1"
  cleanup_home
}
