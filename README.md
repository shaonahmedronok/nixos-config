<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-26.05-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=458588)](https://nixos.org)
[![Niri](https://img.shields.io/badge/Niri-Wayland-FDF6E3?style=for-the-badge&labelColor=458588)](https://github.com/YaLTeR/niri)
[![Flakes](https://img.shields.io/badge/Flakes-Enabled-FDF6E3?style=for-the-badge&logo=nixos&logoColor=FFFFFF&labelColor=458588)](https://nixos.wiki/wiki/Flakes)
[![Home Manager](https://img.shields.io/badge/Home_Manager-26.05-FDF6E3?style=for-the-badge&logoColor=000000&labelColor=458588)](https://nix-community.github.io/home-manager/)

[![Website](https://img.shields.io/badge/shaon.neocities.org-e089a1?style=for-the-badge&labelColor=458588)](https://shaon.neocities.org)

</div>

---

<div align="center">

</div>

**First time on a new machine:**
```bash
# 1. Install NixOS minimal, then generate hardware config
sudo nixos-generate-config

# 2. Clone repo
git clone https://github.com/shaonahmedronok/shaonix /tmp/nixconf

# 3. Copy everything EXCEPT hardware-configuration.nix
sudo cp -r /tmp/nixconf/modules /etc/nixos/
sudo cp /tmp/nixconf/flake.nix /etc/nixos/
sudo cp /tmp/nixconf/flake.lock /etc/nixos/
sudo cp /tmp/nixconf/theme.nix /etc/nixos/
sudo cp /tmp/nixconf/wallpaper.jpg /etc/nixos/

# 4. Track and rebuild
cd /etc/nixos && git init && git add .
sudo nixos-rebuild switch --flake /etc/nixos#shaonix
```

**Daily use (after any edit):**
```bash
cd /etc/nixos
# edit whatever file
sudo nixos-rebuild switch --flake /etc/nixos#shaonix
```

**Monthly update:**
```bash
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#shaonix
nh clean all --keep 3
```
---
