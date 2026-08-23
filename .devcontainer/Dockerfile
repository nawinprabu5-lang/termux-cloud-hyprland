# Arch Linux Cloud Computer with Hyprland Desktop for GitHub Codespaces / Cloud VM
FROM archlinux:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=clouduser
ENV UID=1000
ENV GID=1000
ENV HOME=/home/clouduser

# Update keyrings, mirrors, and base packages
RUN pacman -Syu --noconfirm --needed \
    archlinux-keyring && \
    pacman -S --noconfirm --needed \
    base-devel \
    git \
    curl \
    wget \
    sudo \
    zsh \
    openssh \
    htop \
    fastfetch \
    dbus \
    socat \
    procps-ng \
    net-tools

# Install Graphics, Wayland, and Hyprland Desktop Environment
RUN pacman -S --noconfirm --needed \
    mesa \
    vulkan-swrast \
    xorg-xwayland \
    seatd \
    hyprland \
    waybar \
    wofi \
    kitty \
    swaybg \
    wayvnc \
    novnc \
    python-websockify \
    grim \
    slurp \
    wl-clipboard \
    pavucontrol \
    pulseaudio \
    pulseaudio-alsa \
    firefox \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \
    xdg-utils \
    xdg-user-dirs

# Create non-root user with sudo access
RUN groupadd -g $GID $USER 2>/dev/null || true && \
    useradd -u $UID -g $GID -m -s /bin/zsh $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create runtime directories and set permissions
RUN mkdir -p /tmp/runtime-clouduser /home/$USER/.config && \
    chown -R $USER:$USER /home/$USER /tmp/runtime-clouduser && \
    chmod 0700 /tmp/runtime-clouduser

# Environment variables for headless Wayland / Hyprland
ENV XDG_RUNTIME_DIR=/tmp/runtime-clouduser
ENV WLR_BACKENDS=headless
ENV WLR_LIBINPUT_NO_DEVICES=1
ENV WLR_RENDERER=gles2
ENV XDG_CURRENT_DESKTOP=Hyprland
ENV XDG_SESSION_TYPE=wayland
ENV XDG_SESSION_DESKTOP=Hyprland

USER $USER
WORKDIR /home/$USER

# Setup default shell configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true

EXPOSE 5900 6080 4713 22

CMD ["/bin/zsh"]
