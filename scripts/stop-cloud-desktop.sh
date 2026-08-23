#!/usr/bin/env bash
# stop-cloud-desktop.sh — Stops all cloud desktop services
echo "🛑 Stopping Hyprland cloud desktop services..."
pkill -f "websockify" 2>/dev/null || true
pkill -f "novnc" 2>/dev/null || true
pkill -f "wayvnc" 2>/dev/null || true
pkill -f "hyprland" 2>/dev/null || true
pkill -f "Hyprland" 2>/dev/null || true
pkill -f "waybar" 2>/dev/null || true
echo "✅ All desktop services stopped."
