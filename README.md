# Dotfiles (Hyprland + Wayland)

This repo is managed by `chezmoi` and targets a Wayland/Hyprland desktop.

## What’s included
- Hyprland config with monitor profiles and autolaunch setup.
- Waybar, mako, swaylock/swayidle, wofi, bemenu, kitty.
- Misc configs for fish, fastfetch, nvim, qutebrowser.

## Dependencies (Arch)
Fresh install essentials (pacman):
- `hyprland` `waybar` `mako` `swayidle` `swaylock`
- `swww` `kitty` `dolphin`
- `bemenu` `wofi` `playerctl`
- `polkit-kde-agent`
- `networkmanager` `network-manager-applet`
- `pipewire` `pipewire-pulse` `wireplumber` `pavucontrol`
- `xdg-desktop-portal` `xdg-desktop-portal-hyprland`
- `grim` `slurp` `wl-clipboard`
- `pacman-contrib` (for `checkupdates`)

Fonts (pacman):
- `ttf-iosevka` `noto-fonts-cjk` `noto-fonts-emoji`
- `ttf-nerd-fonts-symbols` `ttf-nerd-fonts-symbols-mono`

Optional (desktop/laptop extras):
- `ddcutil` `i2c-tools` (external brightness control)
- `wlsunset` (night light)
- `fcitx5` `fcitx5-configtool` `fcitx5-gtk` `fcitx5-qt` (input method)
- `nm-connection-editor` (GUI network editor)

Copy/paste (pacman):

```sh
sudo pacman -S hyprland waybar mako swayidle swaylock swww kitty dolphin bemenu wofi playerctl \
  polkit-kde-agent networkmanager network-manager-applet pipewire pipewire-pulse wireplumber \
  pavucontrol xdg-desktop-portal xdg-desktop-portal-hyprland grim slurp wl-clipboard \
  pacman-contrib ttf-iosevka noto-fonts-cjk noto-fonts-emoji ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-mono
```

Copy/paste (optional pacman extras):

```sh
sudo pacman -S ddcutil i2c-tools wlsunset nm-connection-editor fcitx5 fcitx5-configtool \
  fcitx5-gtk fcitx5-qt
```

Copy/paste (optional AUR with yay):

```sh
yay -S hyprshot networkmanager-dmenu
```

## Install
1) Install chezmoi (optional; the script can do it for you).
2) Run the installer:

```sh
./install.sh
```

The installer applies dotfiles, sets executable bits on scripts, and attempts to
apply the wallpaper if `swww` is running. It then offers an interactive monitor
setup (laptop/desktop/custom) that writes `~/.config/hypr/monitors.conf` and can
re-apply the changes. If run with `sudo`, it will chown the installed config
directories back to the invoking user.

## Wallpaper
The default wallpaper is at `~/.config/hypr/wallpaper.jpg`. Autolaunch sets it
via `swww`, and the installer tries to apply it if the `swww` daemon is running.

Copy/paste (apply wallpaper now):

```sh
swww init && swww img ~/.config/hypr/wallpaper.jpg
```

## Notes
- Monitor config is sourced from `~/.config/hypr/monitors.conf`.
- If you update monitor layout, re-run `./install-setup.sh`.
- If you run the installer as root with `sudo`, it will chown the installed
  dotfile dirs back to the invoking user.
