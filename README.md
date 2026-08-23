# 🌌 Termux Cloud Hyprland

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/nawinprabu5-lang/termux-cloud-hyprland)
[![OS](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=arch-linux)](https://archlinux.org)
[![Compositor](https://img.shields.io/badge/Compositor-Hyprland-00f5d4?logo=wayland)](https://hyprland.org)
[![Display](https://img.shields.io/badge/Display-Termux%3AX11-orange)](https://github.com/termux/termux-x11)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Run a full, bleeding-edge **Arch Linux + Hyprland Dynamic Tiling Desktop** in the Cloud (via **GitHub Codespaces** or Cloud VPS) and stream it directly into **Termux:X11 on Android** with 60 FPS fluid animations, rounded corners, blur, and audio support.

---

## ⚡ Highlights

- 🏹 **Pure Arch Linux Base**: Native Hyprland with Waybar, Kitty, Wofi, and Fastfetch.
- 📱 **Native Termux:X11 Integration**: Ultra-smooth rendering, touchscreen support, and hardware acceleration on Android.
- 🎨 **Midnight Neon Rice**: Pre-configured Catppuccin / Midnight Cyan & Neon Purple gradient themes.
- 🔊 **PulseAudio Network Streaming**: Remote cloud audio plays directly on your Android device speakers.
- 🌐 **Web noVNC Fallback**: Access your Hyprland desktop in any web browser at `http://localhost:6080`.
- 💰 **100% Free Forever**: Runs within GitHub's free 120 Core-Hours/month allowance without requiring a credit card.

---

## 🏗️ Architecture

```mermaid
graph LR
    subgraph GitHub Cloud [GitHub Codespaces (Arch Linux)]
        HYPR[Hyprland Compositor]
        BAR[Waybar Status Bar]
        KITTY[Kitty Terminal]
        WOFI[Wofi App Launcher]
        WAYVNC[WayVNC Streamer :5900]
        NOVNC[noVNC Web GUI :6080]
        AUDIO[PulseAudio TCP :4713]
        
        HYPR --> BAR
        HYPR --> KITTY
        HYPR --> WOFI
        HYPR --> WAYVNC
        WAYVNC --> NOVNC
        HYPR --> AUDIO
    end

    subgraph Android Device [Termux & Termux:X11]
        GH_CLI[GitHub CLI / SSH Bridge]
        TX11[Termux:X11 Display Engine :0]
        PA_SINK[Android Speaker Sink]

        GH_CLI <==>|Encrypted Tunnel| WAYVNC
        GH_CLI -->|Direct Render| TX11
        AUDIO -.->|Audio Stream| PA_SINK
    end
```

---

## 🚀 Quick Start Guide

### Step 1: Launch Cloud Desktop (GitHub Codespaces)
Click the badge below to start your free cloud container:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/nawinprabu5-lang/termux-cloud-hyprland)

*(GitHub will build the Arch Linux container and automatically start Hyprland & WayVNC in the background).*

---

### Step 2: Connect from Android (Termux)
In your Termux terminal on Android, run:

```bash
# Clone the repository
git clone https://github.com/nawinprabu5-lang/termux-cloud-hyprland.git
cd termux-cloud-hyprland

# Run the 1-click launcher
./termux/termux-cloud-connect.sh
```

The script will:
1. Ensure `termux-x11` and `tigervnc` are ready.
2. Launch the **Termux:X11** app.
3. Automatically discover your active Codespace and bridge the connection.
4. Stream the Hyprland desktop at your screen's native resolution!

---

## ⌨️ Hyprland Keybindings Cheatsheet

| Key Combination | Action |
| :--- | :--- |
| **`Super + Enter`** | Open **Kitty Terminal** |
| **`Super + D`** | Open **Wofi Application Launcher** |
| **`Super + B`** | Launch **Firefox Web Browser** |
| **`Super + E`** | Open File Manager (Ranger) |
| **`Super + T`** | Open Task Manager (Htop) |
| **`Super + Q`** / **`Super + C`** | Close Active Window |
| **`Super + V`** | Toggle Floating Window |
| **`Super + F`** | Toggle Fullscreen |
| **`Super + 1 .. 6`** | Switch to Workspace 1–6 |
| **`Super + Shift + 1 .. 6`** | Move Window to Workspace 1–6 |
| **`Super + H / J / K / L`** | Focus Left / Down / Up / Right (Vim Keys) |
| **`Super + M`** | Exit Hyprland |

---

## 🛠️ Manual Cloud / VPS Setup

If you want to run this on your own Arch Linux VPS or VM:

```bash
# 1. Clone repo
git clone https://github.com/nawinprabu5-lang/termux-cloud-hyprland.git
cd termux-cloud-hyprland

# 2. Deploy configs
bash scripts/install-configs.sh

# 3. Start desktop
bash scripts/start-cloud-desktop.sh
```

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
