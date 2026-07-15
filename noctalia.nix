{ inputs, pkgs, lib, theme, themeNoHash, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    # Starts noctalia as a systemd user service on graphical-session.target.
    # No spawn-at-startup entry needed in Niri.
    # If nixos-rebuild gives "unknown option programs.noctalia.systemd",
    # remove these two lines and add to home-niri.nix instead:
    #   programs.niri.settings.spawn-at-startup = [
    #     { command = [ "noctalia" "--daemon" ]; }
    #   ];
    systemd.enable = true;

    settings = {
      # Noctalia v5 TOML config expressed as a Nix attrset.
      # Full reference: https://docs.noctalia.dev/v5/configuration/
      # Hot-reloads on rebuild — no restart needed for config changes.

      notification = {
        # Register on org.freedesktop.Notifications, replacing mako.
        enable_daemon = true;
        # Toast popup position. Valid: top-right top-left bottom-right bottom-left top-center bottom-center
        position      = "top-right";
        max_popups    = 5;
      };

      bar = {
        # Valid: top / bottom
        position = "top";
        height   = 36;
        # Customize widgets after first boot via the Noctalia Settings panel
        # or at https://docs.noctalia.dev/v5/configuration/bar-widgets/
      };
    };
  };

  # ── 3-day notification history prune ────────────────────────────────────────
  # Noctalia caps history at 100 entries with no time-based expiry built in.
  # This timer runs every 6 hours and removes entries older than 72 h (3 days).
  #
  # After first boot, find the history file:
  #   find ~/.local -name "*.json" | xargs grep -l '"time"' 2>/dev/null
  # If the path differs from the default below, update NOTIF_FILE and rebuild.

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
            # v5 default (XDG state dir)
            NOTIF_FILE="''${XDG_STATE_HOME:-$HOME/.local/state}/noctalia/notifications.json"
            # Fallback: v4 / alternate location
            if [ ! -f "$NOTIF_FILE" ]; then
              NOTIF_FILE="''${XDG_DATA_HOME:-$HOME/.local/share}/noctalia-shell/notifications.json"
            fi
            # Nothing to do yet
            [ -f "$NOTIF_FILE" ] || exit 0

            # 'time' field is Unix milliseconds (JS Date.now() convention).
            # If v5 stores Unix seconds instead, remove the "* 1000" at the end.
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
    Unit = {
      Description = "Noctalia 3-day notification cleanup — fires every 6 h";
    };
    Timer = {
      OnBootSec       = "5min";   # first run 5 min after boot
      OnUnitActiveSec = "6h";     # repeat every 6 hours
      Persistent      = true;     # catch up if PC was off when due
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
