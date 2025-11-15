#!/usr/bin/env sh
set -eu
mkdir -p ./bin
curl -sSf https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash | bash -s -- -b ./bin/
