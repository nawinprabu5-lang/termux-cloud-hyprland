#!/usr/bin/env bash
# install-configs.sh — Deploy Hyprland & Desktop Rice configurations
set -e

CONFIG_DIR="${HOME}/.config"
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🎨 Setting up Hyprland, Waybar, Kitty, and Wofi configurations..."

mkdir -p "${CONFIG_DIR}/hypr" \
         "${CONFIG_DIR}/waybar" \
         "${CONFIG_DIR}/kitty" \
         "${CONFIG_DIR}/wofi"

cp -r "${WORKSPACE_DIR}/config/hypr/"* "${CONFIG_DIR}/hypr/" 2>/dev/null || true
cp -r "${WORKSPACE_DIR}/config/waybar/"* "${CONFIG_DIR}/waybar/" 2>/dev/null || true
cp -r "${WORKSPACE_DIR}/config/kitty/"* "${CONFIG_DIR}/kitty/" 2>/dev/null || true
cp -r "${WORKSPACE_DIR}/config/wofi/"* "${CONFIG_DIR}/wofi/" 2>/dev/null || true

echo "✅ Configurations installed into ${CONFIG_DIR} successfully!"
