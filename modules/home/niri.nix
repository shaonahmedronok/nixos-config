{ config, pkgs, lib, themeNoHash, ... }:
{
  # Stylix will automatically theme Niri borders/colors if enabled
  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard.repeat-delay = 300;
        keyboard.repeat-rate = 50;
        touchpad.natural-scroll = false;
      };

      layout = {
        gaps = 0;
        strut.top = 0;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = { proportion = 0.5; };
        focus-ring = {
          enable = true;
          width = 4;
          active.color = "#${themeNoHash.base0B}";
          inactive.color = "#${themeNoHash.base01}";
        };
      };

      # Low-spec optimization: Disable heavy animations
      animations = {
        enable = true;
        slowdown = 0.5; # Fast and snappy
      };

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        { command = [ "swww-daemon" ]; }
        { command = [ "udiskie" "-t" ]; }
        { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "kitty";
        "Mod+Space".action = spawn "fuzzel";
        "Mod+B".action = spawn "google-chrome-stable" "--gtk-version=3";
        "Mod+E".action = spawn "thunar";
        "Mod+C".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+Space".action = toggle-window-floating;
        "Mod+Shift+X".action = spawn "hyprlock";
        "Mod+Shift+L".action = spawn "hyprlock";
        
        # Audio & Brightness (matching your Hyprland keys)
        "XF86AudioMute".action = spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle";
        "XF86AudioLowerVolume".action = spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-11%";
        "XF86AudioRaiseVolume".action = spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+11%";

        # Navigation (H J K L)
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;

        # Workspaces 1-9
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action = move-window-to-workspace 1;
        "Mod+Shift+2".action = move-window-to-workspace 2;
        "Mod+Shift+3".action = move-window-to-workspace 3;
        "Mod+Shift+4".action = move-window-to-workspace 4;
        "Mod+Shift+5".action = move-window-to-workspace 5;
        "Mod+Shift+6".action = move-window-to-workspace 6;
        "Mod+Shift+7".action = move-window-to-workspace 7;
        "Mod+Shift+8".action = move-window-to-workspace 8;
        "Mod+Shift+9".action = move-window-to-workspace 9;
      };
    };
  };

  # Keep your lock/idle configs (they work with Niri!)
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
}
