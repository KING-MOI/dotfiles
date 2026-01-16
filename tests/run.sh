#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "$0")" || exit 1
status=0
for file in test_*.sh; do
  echo "$file"
  bash "$file" || status=1
done

if [ "$status" -eq 0 ]; then
  echo "all tests passed"
else
  echo "some tests failed"
fi
exit "$status"
