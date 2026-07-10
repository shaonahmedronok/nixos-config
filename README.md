<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:242424,100:3c3836&height=180&section=header&text=nixos-config&fontSize=36&fontColor=ebdbb2&fontAlignY=38&desc=Declarative%20NixOS%20%C2%B7%20Flakes%20%C2%B7%20Home%20Manager%20%C2%B7%20Niri%20%C2%B7%20Wayland&descAlignY=58&descColor=bdae93"/>

[![Website](https://img.shields.io/badge/shaon.neocities.org-242424?style=for-the-badge&labelColor=3c3836&color=b8bb26)](https://shaon.neocities.org)
[![NixOS](https://img.shields.io/badge/NixOS-26.05-242424?style=for-the-badge&logo=nixos&logoColor=7daea3&labelColor=3c3836)](https://nixos.org)
[![Niri](https://img.shields.io/badge/Niri-Wayland-242424?style=for-the-badge&logo=wayland&logoColor=7fc8ff&labelColor=3c3836)](https://github.com/YaLTeR/niri)
[![Flakes](https://img.shields.io/badge/Flakes-Enabled-242424?style=for-the-badge&logo=nixos&logoColor=fabd2f&labelColor=3c3836)](https://nixos.wiki/wiki/Flakes)
[![Home Manager](https://img.shields.io/badge/Home_Manager-26.05-242424?style=for-the-badge&logoColor=e089a1&labelColor=3c3836)](https://nix-community.github.io/home-manager/)

*Everything declared. Nothing manual. Reproducible from scratch with one rebuild.*

</div>

---

<div align="center">

## System

</div>

| | |
|---|---|
| **OS** | NixOS 26.05 |
| **WM** | Niri (Wayland) |
| **Terminal** | Kitty |
| **Shell** | Fish (default) + Bash, Starship prompt |
| **Editor** | Helix |
| **Code Editor** | VS Code (official Microsoft build, `pkgs.vscode`) |
| **Browser** | Google Chrome |
| **Launcher** | Fuzzel |
| **Bar** | Waybar |
| **Notifications** | Mako |
| **Clipboard** | cliphist + wl-clipboard |
| **Screen Lock** | Hyprlock |
| **Idle Daemon** | Hypridle |
| **Warm Light** | wlsunset (declarative warmth control script, `Super+Shift+W` toggle) |
| **File Manager** | Yazi + Thunar |
| **WiFi TUI** | Impala |
| **Theme** | Custom Gruvbox |
| **Font** | JetBrainsMono Nerd Font |
| **Icons** | Gruvbox-Plus-Dark |
| **Academic Stack** | R + RStudio (`rWrapper`/`rstudioWrapper`), Pandoc, TeX Live (scheme-small), Zotero, Xournal++, Zoom |
| **Swap** | zram (3.8G, priority 5) + disk swapfile (8G, priority 0) |

---

<div align="center">

## Structure

</div>

<pre>
/etc/nixos/
├── academia.nix                         ← R, RStudio, Zotero, TeX Live, Zoom & so on
├── configuration.nix                    ← boot, locale, users, stylix, fonts, swap
├── flake.lock                           ← exact snapshot — always commit 
├── flake.nix                            ← versions pinned
├── general.nix                          ← all system packages + services
├── gtk.nix                              ← GTK + icon theme system-wide
├── hardware-configuration.nix           ← machine-specific — regenerate on new PC
├── home-default.nix                     ← shell, git, gtk, qt, imports, mimeApps, desktopEntries
├── home-niri.nix                        ← Niri + portals (xdg-desktop-portal-gtk explicit)
├── nix.nix                              ← flakes, allowUnfree
├── nixos-niri.nix                       ← keybinds, rules, hypridle, hyprlock
├── pipewire.nix                         ← audio
├── programs.nix                         ← kitty, mpv, fuzzel, mako, yazi, nvim, fastfetch   
├── scripts.nix                          ← screenshot, wallpaper, nightlight, brightness/warmth
├── theme.nix                            ← ONE place for all colors
├── wallpaper.jpg                        ← Wallpaper
└── waybar.nix                           ← bar config + style
├── docs/                                ← cheatsheets and reference documents                    
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

## Where to add new things

</div>

| What | Where |
|---|---|
| New system package | `modules/nixos/features/general.nix` |
| New system service | `modules/nixos/features/general.nix` or new feature file |
| New keybind | `modules/home/niri.nix` |
| New program config | `modules/home/programs.nix` |
| New shell script | `modules/home/scripts.nix` |
| Waybar changes | `modules/home/waybar.nix` |
| Academic/R packages | `modules/nixos/features/academia.nix` |
| Color changes | `theme.nix` only — never hardcode hex anywhere else |

---

<div align="center">

## Design Principles

</div>

- Everything declared. Nothing manual.
- Reproducible from scratch with one rebuild.
- Minimal — nothing installed without a reason.
- Flakes for version pinning — exact reproducibility guaranteed.
- Home Manager as NixOS module — all dotfiles declared in nix files.
- `~/.config` is entirely symlinks to `/nix/store/` — never edited directly.
- `hardware-configuration.nix` is machine-specific — always regenerate fresh.
- `flake.lock` is committed — guarantees identical rebuild anywhere, anytime.
- Colors live in `theme.nix` only — change once, propagates everywhere.
- RStudio ignores ad-hoc R package installs — packages must be declared via `rstudioWrapper.override`, never `install.packages()`.

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

## License

MIT — use freely.

---

*"The burden of proof lies with the addition."*

<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:3c3836,100:242424&height=120&section=footer"/>
</div>
