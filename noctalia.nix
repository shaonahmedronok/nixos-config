{ inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable        = true;
    systemd.enable = true;
  };

  # Declarative: initial bar config (baseline, never touched by GUI)
  home.file.".config/noctalia/config.toml".text = ''
    [bar]
    order = ["main"]

    [bar.main]
    position      = "top"
    thickness     = 34
    margin_ends   = 0
    margin_edge   = 0
    reserve_space = true
    shadow        = false
    radius        = 0
    start         = ["launcher", "wallpaper", "workspaces"]
    center        = ["clock"]
    end           = ["media", "tray", "notifications", "network", "clipboard", "volume", "battery", "session"]

    [notification]
    enable_daemon = true
    position      = "top-right"
    max_popups    = 5
    persistence   = true
  '';

  # Mutable: ensure settings.toml directory exists, but DON'T lock the file
  # Noctalia GUI writes here freely; survives rebuilds
  home.file.".local/state/noctalia/.keep".text = "";
}
