{ config, pkgs, lib, theme, themeNoHash, ... }:
{

home.packages = with pkgs; [
    xwayland-satellite  # The X11 bridge
    qt5.qtwayland       # Wayland support for Qt5 apps (KeePassXC)
    qt6.qtwayland       # Wayland support for Qt6 apps
  ];

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL                      = "1";
    XDG_CURRENT_DESKTOP = "niri:GNOME";
    XDG_SESSION_TYPE                    = "wayland";
    XDG_SESSION_DESKTOP                 = "niri";
    QT_QPA_PLATFORM                     = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_IM_MODULE   = "fcitx";    # Qt apps (KeePassXC)
    XMODIFIERS     = "@im=fcitx"; # XWayland apps
    GDK_BACKEND                         = "wayland,x11";
  };

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 300
            repeat-rate  50
        }
        focus-follows-mouse
    }

    cursor {
        xcursor-theme "macOS"
        xcursor-size 24
    }
    
    output "HDMI-A-2" {
        mode "1280x1024@75"
    }


    layout {
        gaps 1
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 3
            active-color   "#${themeNoHash.base0B}"
            inactive-color "#${themeNoHash.base01}"
        }
        border {
            width 3
            active-color   "#${themeNoHash.base0D}"
            inactive-color "#${themeNoHash.base01}"
        }
    }

    animations {
        slowdown 0.5
    }

    prefer-no-csd

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    window-rule {
        match app-id="pavucontrol"
        open-floating true
    }
    window-rule {
        match app-id="nm-connection-editor"
        open-floating true
    }
    window-rule {
        match title="File Operation Progress"
        open-floating true
    }
    window-rule {
        match title="Confirm to replace files"
        open-floating true
    }
    window-rule {
        match app-id="xdg-desktop-portal-gtk"
        open-floating true
    }
    window-rule {
        match app-id="imv"
        open-floating true
    }
    window-rule {
        match app-id="org.inkscape.Inkscape"
        open-floating true
    }

    spawn-at-startup "udiskie" "-t"
    spawn-at-startup "wlsunset" "-t" "4500" "-T" "4500"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "wl-clip-persist" "--clipboard" "regular"
    spawn-at-startup "awww-daemon"
    // Autostart the XWayland bridge
    spawn-at-startup "xwayland-satellite"

    binds {
        Mod+Return { spawn "kitty"; }
        Mod+period { spawn "sh" "-c" "cat ~/.config/.emoji | fuzzel --dmenu | awk '{print $1}' | wl-copy && wtype -M ctrl v"; }
        Mod+Space  { spawn "fuzzel"; }
        Mod+B      { spawn "google-chrome-stable" "--gtk-version=3"; }
        Mod+E      { spawn "thunar"; }
        Mod+Alt+W { spawn "noctalia" "msg" "panel-toggle" "noctalia/wallhaven:browser"; }
        Mod+V      { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }
        Mod+Shift+X { spawn "hyprlock"; }
        Mod+N       { spawn "makoctl" "dismiss"; }
        Mod+Shift+N { spawn "makoctl" "dismiss" "--all"; }
        Mod+Z       { spawn "bash" "/home/az/.local/bin/screenshot-capture-wayland.sh" "region"; }
        Mod+Shift+Z { spawn "bash" "/home/az/.local/bin/screenshot-capture-wayland.sh"; }
        Mod+W { spawn "/home/az/dirrr/wallpapers/cycle-wallpaper.sh"; }

        Mod+C           { close-window; }
        Mod+F           { maximize-column; }
        Mod+Shift+Space { toggle-window-floating; }

        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-right; }

        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down-or-to-workspace-down; }
        Mod+Shift+K     { move-window-up-or-to-workspace-up; }
        Mod+Shift+L     { move-column-right; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up    { move-window-up-or-to-workspace-up; }
        Mod+Shift+Right { move-column-right; }

        Mod+Shift+period { move-column-to-monitor-right; }
        Mod+Shift+comma  { move-column-to-monitor-left; }

        XF86AudioMute        { spawn "pactl" "set-sink-mute"   "@DEFAULT_SINK@" "toggle"; }
        XF86AudioLowerVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-1%"; }
        XF86AudioRaiseVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+1%"; }
        Mod+F1 { spawn "pactl" "set-sink-mute"   "@DEFAULT_SINK@" "toggle"; }
        Mod+F2 { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%"; }
        Mod+F3 { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%"; }

        Mod+Page_Up   { spawn "ddcutil" "setvcp" "10" "+" "15"; }
        Mod+Page_Down { spawn "ddcutil" "setvcp" "10" "-" "15"; }

        Mod+Shift+W { spawn "sh" "-c" "pgrep wlsunset && pkill wlsunset || nohup wlsunset -t 1000 -T 1001 -l 90 -L 0 &"; }









	Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        Mod+Shift+E { quit; }
    }
  '';

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor        = false;
        ignore_empty_input = true;
      };
      background = [{
        path        = "screenshot";
        blur_passes = 3;
        blur_size   = 8;
        brightness  = 0.8;
        contrast    = 0.9;
      }];
      input-field = [{
        size              = "250, 55";
        position          = "0, -80";
        monitor           = "";
        dots_center       = true;
        fade_on_empty     = false;
        outline_thickness = 3;
        outer_color       = "rgb(${themeNoHash.base0B})";
        inner_color       = "rgb(${themeNoHash.base00})";
        font_color        = "rgb(${themeNoHash.base06})";
        placeholder_text  = "<i>Password...</i>";
        shadow_passes     = 2;
        halign            = "center";
        valign            = "center";
      }];
      label = [{
        text        = "$TIME";
        color       = "rgba(${themeNoHash.base06}ff)";
        font_size   = 52;
        font_family = "JetBrainsMono Nerd Font";
        position    = "0, 80";
        halign      = "center";
        valign      = "center";
      }];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd         = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        { timeout = 300; on-timeout = "loginctl lock-session"; }
        { timeout = 600; on-timeout = "systemctl suspend"; }
      ];
    };
  };
}
