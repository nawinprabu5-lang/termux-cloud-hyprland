#!/usr/bin/env bash
# start-cloud-desktop.sh — Starts Headless Hyprland, WayVNC, and noVNC on Cloud Machine
set -e

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/runtime-clouduser}"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 0700 "$XDG_RUNTIME_DIR"

export WLR_BACKENDS=headless
export WLR_LIBINPUT_NO_DEVICES=1
export WLR_RENDERER=gles2
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

echo "🚀 [1/4] Initializing D-Bus Session..."
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "🔊 [2/4] Starting PulseAudio Network Streamer..."
pulseaudio --kill 2>/dev/null || true
pulseaudio --start --exit-idle-time=-1 \
    --load="module-native-protocol-tcp auth-anonymous=1" 2>/dev/null || true

echo "🌌 [3/4] Starting Headless Hyprland Compositor..."
pkill -f "hyprland" 2>/dev/null || true
Hyprland > /tmp/hyprland.log 2>&1 &
HYPR_PID=$!

# Wait for Wayland socket to be ready
echo "⏳ Waiting for Wayland display socket..."
for i in {1..30}; do
    if [ -S "$XDG_RUNTIME_DIR/wayland-0" ] || [ -S "$XDG_RUNTIME_DIR/wayland-1" ]; then
        export WAYLAND_DISPLAY="wayland-0"
        [ -S "$XDG_RUNTIME_DIR/wayland-1" ] && export WAYLAND_DISPLAY="wayland-1"
        echo "✅ Connected to $WAYLAND_DISPLAY"
        break
    fi
    sleep 0.5
done

echo "🖥️  [4/4] Starting WayVNC (Port 5900) & noVNC Web (Port 6080)..."
pkill -f "wayvnc" 2>/dev/null || true
pkill -f "websockify" 2>/dev/null || true

# Start WayVNC
wayvnc --render-cursor 0.0.0.0 5900 > /tmp/wayvnc.log 2>&1 &
sleep 1

# Start noVNC web proxy (for browser access)
if [ -d "/usr/share/novnc" ]; then
    websockify --web /usr/share/novnc/ 6080 localhost:5900 > /tmp/novnc.log 2>&1 &
elif command -v novnc_proxy &>/dev/null; then
    novnc_proxy --vnc localhost:5900 --listen 6080 > /tmp/novnc.log 2>&1 &
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Hyprland Cloud Desktop is LIVE & READY!"
echo "   • Native WayVNC:    localhost:5900 (Use with Termux-X11 bridge)"
echo "   • Web noVNC:        http://localhost:6080 (Browser GUI)"
echo "   • Audio Stream:     localhost:4713 (PulseAudio)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
