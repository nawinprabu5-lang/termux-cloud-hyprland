# Ubuntu 22.04 Cloud Computer with Full GUI Desktop & GPU/CPU Acceleration
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=vscode
ENV DISPLAY=:1

# Install XFCE4, X11 utilities, TigerVNC, noVNC, PulseAudio, Firefox, and Tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    dbus-x11 \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
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

# Set up VNC passwordless and permissions
RUN mkdir -p /home/vscode/.vnc /home/vscode/.config/xfce4 && \
    chown -R vscode:vscode /home/vscode

USER vscode
WORKDIR /home/vscode

EXPOSE 5901 6080 4713 22

CMD ["/bin/bash"]
