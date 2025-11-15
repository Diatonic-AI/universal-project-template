#!/usr/bin/env sh
set -eu
echo "Installing pre-commit (if possible) and hooks..."
if command -v pipx >/dev/null 2>&1; then pipx install pre-commit || true; fi
if command -v pip3 >/dev/null 2>&1; then pip3 install --user pre-commit || true; fi
if command -v pre-commit >/dev/null 2>&1; then pre-commit install; fi
echo "Done."
