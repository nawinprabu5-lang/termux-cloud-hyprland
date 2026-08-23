#!/usr/bin/env bash
# start-cloud-desktop.sh — Starts Cloud XFCE4 Desktop, TigerVNC, and noVNC
set -e

export USER="${USER:-vscode}"
export HOME="/home/${USER}"
export DISPLAY=:1

echo "🔊 [1/4] Starting PulseAudio Network Streamer..."
pulseaudio --kill 2>/dev/null || true
pulseaudio --start --exit-idle-time=-1 \
    --load="module-native-protocol-tcp auth-anonymous=1" 2>/dev/null || true

echo "⚙️  [2/4] Setting up VNC xstartup for XFCE4..."
mkdir -p "${HOME}/.vnc"
cat << 'EOF' > "${HOME}/.vnc/xstartup"
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=xfce
exec startxfce4
EOF
chmod +x "${HOME}/.vnc/xstartup"

echo "🖥️  [3/4] Starting TigerVNC Display Server (:1 on port 5901)..."
vncserver -kill :1 2>/dev/null || true
pkill -f "Xvnc" 2>/dev/null || true
sleep 1

vncserver :1 \
    -geometry 1920x1080 \
    -depth 24 \
    -SecurityTypes None \
    -localhost no > /tmp/vncserver.log 2>&1

echo "🌐 [4/4] Starting noVNC Web Proxy (Port 6080)..."
pkill -f "websockify" 2>/dev/null || true
pkill -f "novnc" 2>/dev/null || true

if [ -d "/usr/share/novnc" ]; then
    websockify --web /usr/share/novnc/ 6080 localhost:5901 > /tmp/novnc.log 2>&1 &
elif command -v novnc_proxy &>/dev/null; then
    novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Cloud Desktop is ONLINE & READY!"
echo "   • Native VNC Server:  Port 5901 (Stream directly to Termux:X11)"
echo "   • Web noVNC Browser:  http://localhost:6080"
echo "   • PulseAudio Stream:  Port 4713"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit 0
