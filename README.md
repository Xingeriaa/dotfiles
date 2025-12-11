
---

# 🌑 Xingeria Dotfiles — Hyprland Setup

A clean, keyboard-centric Wayland workflow powered by **Hyprland**, **Fish**, **Kitty**, **Waybar**, **swww**, **bemenu**, **mako**, and **wofi**.
Fully modular dotfiles designed for multi-monitor setups and fast customization.

---

## 📂 Directory Structure

```
bemenu/                 # Launcher (bemenu) + scripts
dolphinrc               # Dolphin file manager config
fastfetch/              # Terminal system fetch
fish/                   # Fish shell configuration
hypr/                   # Hyprland configs, rules, keybinds
kitty/                  # Kitty terminal configuration
mako/                   # Notification styling
networkmanager-dmenu/   # Network menu with bemenu backend
nvim/                   # Neovim setup
presets/                # GTK themes / Gradience presets
swaylock/               # Swaylock-effects lockscreen
Wallpapers/             # Wallpapers directory
waybar/                 # Waybar configuration
wofi/                   # Wofi powermenu + themes
```

---

# 🚀 Hyprland Overview

Your Hyprland config provides:

* Clean visual defaults (rounded corners, blur, shadows off)
* `swww-daemon` auto-launch for wallpaper handling
* Multi-monitor support using `monitor=<name>,<resolution>,<pos>,<scale>`
* Carbon-inspired color aesthetics
* Complete custom keybind system
* Waybar, wofi, and notifications layered blur
* Hyprlock integrated
* Gesture support for workspace navigation
* Input configuration (Colemak DH ISO support)

Screenshot placeholder (replace with your own):

> ![placeholder](https://github.com/Zerodya/dotfiles/raw/main/EvoCarbon%20Hyprland/screenshots/clean.png)

---

# 🐟 Fish as Default Shell

This dotfiles setup is optimized around **Fish**:

* Custom functions
* Syntax highlighting
* Starship prompt
* Alias and plugin structure
* Autocomplete defaults

To set fish as your default shell:

```
chsh -s /usr/bin/fish
```

### Optional: Install fisherman plugins

```
fish_config
```

---

# 🖼 Wallpaper Setup (swww)

Your system uses **swww**, a fast Wayland wallpaper daemon.

### Start the daemon automatically

(live in your Hypr config)

```ini
exec-once = swww-daemon --format argb --layer background
```

### Set a wallpaper manually

```
swww img ~/Wallpapers/wallpaper.png --transition-type grow --transition-fps 60
```

### Recommended folder structure

```
~/Wallpapers/
    ├── minimal/
    ├── anime/
    ├── gradients/
    └── carbon/
```

### You can also automate random wallpapers:

```
swww img "$(find ~/Wallpapers -type f | shuf -n 1)"
```

---

# 🖥 Multi-Monitor Setup (Hyprland)

Hyprland requires **explicit monitor definitions**.
Your README now includes a dedicated guide for setting them up correctly.

### 1. Find your monitor names

Run:

```
hyprctl monitors
```

Example output:

```
Monitor eDP-1 (internal)
Monitor HDMI-A-1 (external)
```

### 2. Example 2-monitor setup

```ini
monitor=eDP-1,1920x1080@60,0x0,1
monitor=HDMI-A-1,2560x1440@75,1920x0,1
```

### 3. Auto-detect preferred modes

```ini
monitor=eDP-1,preferred,auto,1
monitor=HDMI-A-1,preferred,auto,1
```

### 4. Disable a monitor

```ini
monitor=HDMI-A-1,disable
```

### 5. Set workspace rules per-monitor

```ini
workspace=1,monitor:eDP-1
workspace=2,monitor:eDP-1
workspace=3,monitor:HDMI-A-1
workspace=4,monitor:HDMI-A-1
```

### 6. Mirror mode

```ini
monitor=HDMI-A-1,preferred,mirror,eDP-1
```

If you want, I can also add:

* A dynamic monitor script (`hypr-monitor-switch.sh`)
* Auto-detect monitor hotplug using `udev` + Hyprland
* A 3-monitor setup template

Just ask!

---

# ⌨️ Keybinds Overview

Your actual keybinds from the config:

| Keys                         | Action                       |
| ---------------------------- | ---------------------------- |
| **Alt + Return**             | Launch terminal (Kitty)      |
| **Alt + Q**                  | Kill active window           |
| **Super + M**                | Exit Hyprland                |
| **Super + F**                | Fullscreen                   |
| **Super + E**                | Open Dolphin                 |
| **Alt + F**                  | Toggle floating              |
| **Alt + X**                  | Launcher (bemenu)            |
| **Alt + Z**                  | Powermenu (wofi)             |
| **Alt + S**                  | Toggle split                 |
| **Super + W/A/S/D**          | Move focus                   |
| **Alt + F1**                 | Screenshot                   |
| **Super + L**                | Lock (hyprlock)              |
| **Super + J**                | Start Waybar                 |
| **Alt or Ctrl + 1–5**        | Switch workspace (1–10)      |
| **Super / Ctrl+Shift + 1–5** | Move window to workspace     |
| **Super + Scroll**           | Cycle workspaces             |
| **Super + LMB/RMB**          | Move / Resize window         |
| **Media keys**               | Volume, brightness, playback |

---

# 📦 Required Packages

```
yay -S --needed \
waybar-hyprland-git mako wofi bemenu bemenu-wayland \
adw-gtk3 gradience j4-dmenu-desktop swayidle swaylock-effects-git \
swww nerd-fonts-meta ttf-material-design-icons-extended \
networkmanager-dmenu-git brightnessctl playerctl fish starship
```

Optional:

* `wlsunset` — night light
* `ddcutil`, `i2c-tools` — external monitor brightness

---

# 🔧 Post-Install Steps

### 1. Make scripts executable

```
chmod +x ~/.config/bemenu/*/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/wofi/*/*.sh
```

### 2. Apply GTK Theme

Use your JSON preset via Gradience → Apply → Logout.

### 3. Set default Fish shell

```
chsh -s /usr/bin/fish
```

### 4. For Laptop Users

Use the laptop Hyprland variant (if provided):

```
mv ~/.config/hypr/hyprland_laptop.conf ~/.config/hypr/hyprland.conf
```

---

# 🙌 Credits

Thanks to the Hyprland, Fish, and Waybar communities for tools, inspiration, and theming ideas.

---

If you'd like, I can also create:

📌 **A fully structured installer script (`install.sh`)**
📌 **A screenshot gallery section**
📌 **A color palette card for your theme**
📌 **Badges + branding banner for the top of your README**
📌 **Auto-wallpaper rotation script for swww**

Just tell me!

