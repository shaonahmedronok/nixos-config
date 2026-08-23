<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-26.05-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=458588)](https://nixos.org)
[![Niri](https://img.shields.io/badge/Niri-Wayland-FDF6E3?style=for-the-badge&labelColor=458588)](https://github.com/YaLTeR/niri)
[![Noctalia Shell](https://img.shields.io/badge/Noctalia-Shell-FDF6E3?style=for-the-badge&labelColor=458588)](https://github.com/noctalia-dev/noctalia-shell)[![Flakes](https://img.shields.io/badge/Flakes-Enabled-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=458588)](https://nixos.wiki/wiki/Flakes)
[![Home Manager](https://img.shields.io/badge/Home_Manager-26.05-FDF6E3?style=for-the-badge&logoColor=000000&labelColor=458588)](https://nix-community.github.io/home-manager/)

[![Website](https://img.shields.io/badge/shaon.neocities.org-e089a1?style=for-the-badge&labelColor=458588)](https://shaon.neocities.org)

</div>

---


## System

</div>

| | |
|---|---|
| **OS** | NixOS 26.05 (Yarara) |
| **WM** | Niri (Wayland) |
| **Terminal** | Kitty |
| **Shell** | Fish (default) + Bash |
| **Editor** | Helix |
| **Launcher** | Fuzzel |
| **Clipboard** | cliphist + wl-clipboard |
| **Screen Lock** | Hyprlock |
| **Warm Light** | wlsunset |
| **File Manager** | Yazi + nautilus |
| **Font** | JetBrainsMono Nerd Font |
| **Swap** | zram (3.8G, priority 5) + disk swapfile (8G, priority 0) |

---

<div align="center">

## Structure

</div>

<pre>
/etc/nixos/

├── academia.nix
├── configuration.nix
├── flake.lock
├── flake.nix
├── general.nix
├── gtk.nix
├── hardware-configuration.nix
├── home-default.nix
├── home-niri.nix
├── nix.nix
├── nixos-niri.nix
├── pipewire.nix
├── programs.nix
├── scripts.nix
├── theme.nix
└── wallpaper.jpg

├── docs/                                
├── asset/                               
</pre>

---

<div align="center">

## Apply

</div>

**First time on a new machine:**
```bash
# 1. Install NixOS minimal, then generate hardware config
sudo nixos-generate-config

# 2. Clone repo
git clone https://github.com/shaonahmedronok1/nixos-config /tmp/nixconf

# 3. Copy everything EXCEPT hardware-configuration.nix
sudo cp -r /tmp/nixconf/modules /etc/nixos/
sudo cp /tmp/nixconf/flake.nix /etc/nixos/
sudo cp /tmp/nixconf/flake.lock /etc/nixos/
sudo cp /tmp/nixconf/theme.nix /etc/nixos/
sudo cp /tmp/nixconf/wallpaper.jpg /etc/nixos/

# 4. Track and rebuild
cd /etc/nixos && git init && git add .
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

**Daily use — after any edit:**
```bash
cd /etc/nixos
# edit whatever file
git add .
sudo nixos-rebuild switch --flake /etc/nixos#nixos
git commit -m "what changed"
git push
```

**Monthly update:**
```bash
cd /etc/nixos
sudo nix flake update
git add .
sudo nixos-rebuild switch --flake /etc/nixos#nixos
nh clean all --keep 3
git commit -m "update"
git push
```

**Rollback if broken:**
```bash
sudo nixos-rebuild switch --rollback
```

---

<div align="center">

## Rules — never break these

</div>
```bash
# Always git add . BEFORE nixos-rebuild — flakes only see tracked files
# Never edit ~/.config directly — symlinks, will be overwritten on rebuild
# Never copy hardware-configuration.nix to a new machine — always regenerate
# Always commit flake.lock after nix flake update
# Never change home.stateVersion or system.stateVersion
# One file at a time — edit, rebuild, confirm, then commit
```

---
