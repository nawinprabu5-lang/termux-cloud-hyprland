#!/usr/bin/env bash
# install-configs.sh — Initialize user configs
set -e

USER_HOME="${HOME:-/home/vscode}"
mkdir -p "${USER_HOME}/.config" "${USER_HOME}/Desktop"

echo "✅ Environment initialized for ${USER_HOME}"
exit 0
