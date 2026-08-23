#!/data/data/com.termux/files/usr/bin/bash
# ╔═══════════════════════════════════════════════════════════════════╗
# ║  Termux Cloud Desktop Connect — Android Client Bridge             ║
# ╚═══════════════════════════════════════════════════════════════════╝

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🖥️  Termux Cloud Desktop Bridge"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Check Dependencies
MISSING_PKGS=""
command -v termux-x11 >/dev/null 2>&1 || MISSING_PKGS="$MISSING_PKGS termux-x11-nightly"
command -v vncviewer >/dev/null 2>&1 || MISSING_PKGS="$MISSING_PKGS tigervnc-viewer"
command -v gh >/dev/null 2>&1 || MISSING_PKGS="$MISSING_PKGS gh"
command -v ssh >/dev/null 2>&1 || MISSING_PKGS="$MISSING_PKGS openssh"

if [ -n "$MISSING_PKGS" ]; then
    echo "📦 Installing required Termux packages:$MISSING_PKGS..."
    pkg update -y && pkg install -y $MISSING_PKGS || true
fi

# 2. Check Display Server (:0)
echo "📱 [1/3] Initializing Termux:X11 Display..."
export XDG_RUNTIME_DIR="${TMPDIR:-/data/data/com.termux/files/usr/tmp}"
export DISPLAY=:0

if ! pgrep -f "termux-x11 :0" >/dev/null 2>&1; then
    termux-x11 :0 &
    sleep 1.5
fi

# Bring Termux:X11 App to Foreground
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true
sleep 0.5

# 3. Connection Setup (GitHub Codespaces or Remote SSH)
echo "☁️  [2/3] Establishing Secure Cloud Tunnel..."

CODESPACE_NAME="$1"

# If no codespace provided as argument, check via gh CLI
if [ -z "$CODESPACE_NAME" ]; then
    if command -v gh >/dev/null 2>&1; then
        echo "🔍 Discovering active GitHub Codespaces..."
        CS_LIST=$(gh cs list --json name,displayName,state --jq '.[] | select(.state=="Available") | .name' 2>/dev/null || true)
        if [ -n "$CS_LIST" ]; then
            CODESPACE_NAME=$(echo "$CS_LIST" | head -n 1)
            echo "🎯 Auto-selected Codespace: $CODESPACE_NAME"
        fi
    fi
fi

if [ -n "$CODESPACE_NAME" ]; then
    echo "🔗 Creating port forward tunnel (5901 & 4713) to: $CODESPACE_NAME..."
    pkill -f "gh cs ssh.*5901" 2>/dev/null || true
    gh cs ssh -c "$CODESPACE_NAME" -- -N -L 5901:localhost:5901 -L 4713:localhost:4713 &
    TUNNEL_PID=$!
    sleep 2
else
    echo "💡 Using direct localhost:5901 (or active port forward)."
fi

# 4. Stream Cloud Desktop to Termux:X11
echo "🚀 [3/3] Streaming Cloud Desktop into Termux:X11..."
if command -v vncviewer >/dev/null 2>&1; then
    DISPLAY=:0 vncviewer \
        -FullScreen=1 \
        -ViewOnly=0 \
        -PreferredEncoding=ZRLE \
        -AutoPass=1 \
        localhost:5901 || true
else
    echo "⚠️  vncviewer not found. Please install tigervnc: pkg install tigervnc"
fi

# Cleanup on exit
if [ -n "$TUNNEL_PID" ]; then
    kill "$TUNNEL_PID" 2>/dev/null || true
fi
echo "👋 Cloud desktop session closed."
