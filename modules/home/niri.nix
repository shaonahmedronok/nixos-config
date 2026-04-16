{ config, pkgs, themeNoHash, ... }:
{
  # We manage the config as a raw KDL file to bypass Home Manager module limitations
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            repeat-delay 300
            repeat-rate 50
        }
        touchpad {
            off
        }
    }

    layout {
        gaps 0
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#${themeNoHash.base0B}"
            inactive-color "#${themeNoHash.base01}"
        }

        border {
            off
        }
    }

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "swww-daemon"
    spawn-at-startup "udiskie -t"
    spawn-at-startup "wl-paste --watch cliphist store"

    animations {
        slowdown 0.5
    }

    binds {
        // Terminal & Core Apps
        Mod+Return { spawn "kitty"; }
        Mod+Space { spawn "fuzzel"; }
        Mod+B { spawn "google-chrome-stable" "--gtk-version=3"; }
        Mod+E { spawn "thunar"; }
        Mod+C { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+Space { toggle-window-floating; }
        Mod+V { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }
        
        // Lock
        Mod+Shift+X { spawn "hyprlock"; }
        
        // Navigation (HJKL)
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-or-workspace-down; }
        Mod+K { focus-window-or-workspace-up; }

        // Column Resizing
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Audio Control
        XF86AudioMute { spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"; }
        XF86AudioLowerVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-11%"; }
        XF86AudioRaiseVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+11%"; }

        // Workspace Switching
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // Move Windows to Workspaces
        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        // Quit Niri
        Mod+Shift+E { quit; }
    }
  '';

  # System services that remain active
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
}
