# Ubuntu 22.04 LTS Cloud Computer for GitHub Codespaces & Termux:X11
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=vscode
ENV DISPLAY=:1
ENV VNC_RESOLUTION=1920x1080
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080

# 1. Install XFCE4 Desktop, TigerVNC, Audio, and Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    dbus-x11 \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-tools \
    novnc \
    websockify \
    python3-websockify \
    python3-numpy \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    firefox \
    htop \
    neofetch \
    curl \
    wget \
    git \
    sudo \
    net-tools \
    socat \
    mesa-utils \
    x11-xserver-utils \
    fonts-jetbrains-mono \
    fonts-noto-color-emoji \
    fonts-font-awesome && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Setup VNC xstartup for XFCE4
RUN mkdir -p /home/vscode/.vnc /home/vscode/.config/xfce4 && \
    cat << 'EOF' > /home/vscode/.vnc/xstartup
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=xfce
exec startxfce4
EOF
RUN chmod +x /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode

# 3. Create bulletproof desktop initialization daemon script
RUN cat << 'EOF' > /usr/local/share/desktop-init.sh
#!/usr/bin/env bash
set -e

USER_NAME="vscode"
LOG_FILE="/tmp/desktop-init.log"
DISPLAY_NUM=":1"
VNC_PORT="5901"
NOVNC_PORT="6080"

echo "[$(date)] 🚀 Starting Cloud Desktop Services..." | tee -a "$LOG_FILE"

# Start DBus
if [ ! -d "/var/run/dbus" ]; then
    sudo mkdir -p /var/run/dbus
fi
sudo /etc/init.d/dbus start 2>/dev/null || true

# Start PulseAudio Network Streaming
pulseaudio --kill 2>/dev/null || true
pulseaudio --start --exit-idle-time=-1 --load="module-native-protocol-tcp auth-anonymous=1" 2>/dev/null || true

# Clean up stale locks
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

# Start TigerVNC Server
if ! pgrep -f "Xvnc :1" >/dev/null; then
    echo "[$(date)] 🖥️  Starting TigerVNC on port ${VNC_PORT}..." | tee -a "$LOG_FILE"
    vncserver -kill :1 2>/dev/null || true
    vncserver :1 \
        -geometry 1920x1080 \
        -depth 24 \
        -SecurityTypes None \
        -localhost no >> "$LOG_FILE" 2>&1
fi

# Start noVNC Web Server
if ! pgrep -f "websockify.*${NOVNC_PORT}" >/dev/null; then
    echo "[$(date)] 🌐 Starting noVNC on port ${NOVNC_PORT}..." | tee -a "$LOG_FILE"
    if [ -d "/usr/share/novnc" ]; then
        websockify --web /usr/share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT} >> "$LOG_FILE" 2>&1 &
    elif [ -f "/usr/share/novnc/utils/novnc_proxy" ]; then
        /usr/share/novnc/utils/novnc_proxy --vnc localhost:${VNC_PORT} --listen ${NOVNC_PORT} >> "$LOG_FILE" 2>&1 &
    fi
fi

echo "[$(date)] ✨ Cloud Desktop is LIVE on port ${VNC_PORT} and web http://localhost:${NOVNC_PORT}" | tee -a "$LOG_FILE"
EOF
RUN chmod +x /usr/local/share/desktop-init.sh

USER vscode
WORKDIR /home/vscode

EXPOSE 5901 6080 4713 22

CMD ["/bin/bash"]
