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
  '';

  # Mutable: ensure settings.toml directory exists, but DON'T lock the file
  # Noctalia GUI writes here freely; survives rebuilds
  home.file.".local/state/noctalia/.keep".text = "";

  home.packages = [ pkgs.jq ];

  systemd.user.services.noctalia-notif-prune = {
    Unit = {
      Description = "Prune Noctalia notification history older than 3 days";
      After       = [ "noctalia.service" ];
    };
    Service = {
      Type      = "oneshot";
      ExecStart =
        let
          script = pkgs.writeShellScript "noctalia-notif-prune" ''
            NOTIF_FILE="''${XDG_STATE_HOME:-$HOME/.local/state}/noctalia/notifications.json"
            if [ ! -f "$NOTIF_FILE" ]; then
              NOTIF_FILE="''${XDG_DATA_HOME:-$HOME/.local/share}/noctalia-shell/notifications.json"
            fi
            [ -f "$NOTIF_FILE" ] || exit 0
            CUTOFF_MS=$(( ( $(${pkgs.coreutils}/bin/date +%s) - 259200 ) * 1000 ))
            TMP=$(${pkgs.coreutils}/bin/mktemp)
            ${pkgs.jq}/bin/jq --argjson c "$CUTOFF_MS" \
              '[.[] | select(.time > $c)]' \
              "$NOTIF_FILE" > "$TMP" \
              && ${pkgs.coreutils}/bin/mv "$TMP" "$NOTIF_FILE" \
              || ${pkgs.coreutils}/bin/rm -f "$TMP"
          '';
        in "${script}";
    };
  };

  systemd.user.timers.noctalia-notif-prune = {
    Unit.Description = "Noctalia 3-day notification cleanup";
    Timer = {
      OnBootSec       = "5min";
      OnUnitActiveSec = "6h";
      Persistent      = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
