{ config, pkgs, lib, ... }:
{


  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL                      = "1";
    XDG_CURRENT_DESKTOP                 = "niri:GNOME";
    XDG_SESSION_TYPE                    = "wayland";
    XDG_SESSION_DESKTOP                 = "niri";
    QT_QPA_PLATFORM                     = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_IM_MODULE                        = "fcitx";
    XMODIFIERS                          = "@im=fcitx";
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
        xcursor-theme "Adwaita"
        xcursor-size 24
    }

    output "HDMI-A-2" {
        mode "1280x1024@75"
    }


layout {
    gaps 6
    center-focused-column "never"
    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }
    default-column-width { proportion 0.5; }
    struts {
        left   8
        right  8
        top    8
        bottom 8
    }
    focus-ring {
    width 3
    active-color   "#458588"
    inactive-color "#D9D3C3"
}
border {
    width 3
    active-color   "#458588"
    inactive-color "#D9D3C3"
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
    match app-id="mako"
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

    spawn-at-startup "udiskie" "-t"
    spawn-at-startup "mako"
    spawn-at-startup "swaybg" "-i" "/etc/nixos/wallpaper.jpg" "-m" "fill"
    spawn-at-startup "wlsunset" "-t" "4500" "-T" "4500"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "wl-clip-persist" "--clipboard" "regular"
    spawn-at-startup "xwayland-satellite"

    binds {
        // ── Apps ──────────────────────────────────────────────────────
        Mod+Return      { spawn "kitty"; }
        Mod+Space       { spawn "fuzzel"; }
        Mod+W { spawn "bash" "/home/shaonix/.local/bin/wallpaper-cycle.sh"; }
        Mod+B { spawn "google-chrome-stable"; }
        Mod+V           { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

        // ── Windows ───────────────────────────────────────────────────
        Mod+C           { close-window; }
        Mod+F           { maximize-column; }
        Mod+Shift+Space { toggle-window-floating; }

        // ── Focus ─────────────────────────────────────────────────────
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-right; }

        // ── Move ──────────────────────────────────────────────────────
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

        // ── Workspaces ────────────────────────────────────────────────
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

        // ── Volume — physical knob + keyboard ─────────────────────────
        XF86AudioMute        { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "mute"; }
        XF86AudioLowerVolume { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "down"; }
        XF86AudioRaiseVolume { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "up"; }
        Mod+F1 { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "mute"; }
        Mod+F2 { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "down"; }
        Mod+F3 { spawn "bash" "/home/shaonix/.local/bin/volume-control.sh" "up"; }


        // ── Colour temperature ────────────────────────────────────────
        Mod+Alt+Up   { spawn "bash" "/home/shaonix/.local/bin/wlsunset-adjust.sh" "up"; }
        Mod+Alt+Down { spawn "bash" "/home/shaonix/.local/bin/wlsunset-adjust.sh" "down"; }
        Mod+Shift+W  { spawn "sh" "-c" "pgrep wlsunset && pkill wlsunset || nohup wlsunset -t 1000 -T 1001 -l 90 -L 0 &"; }

        // ── Screenshot ────────────────────────────────────────────────
        Mod+Z       { spawn "bash" "/home/shaonix/.local/bin/screenshot-capture-wayland.sh" "region"; }
        Mod+Shift+Z { spawn "bash" "/home/shaonix/.local/bin/screenshot-capture-wayland.sh"; }

        // ── Info popups ───────────────────────────────────────────────
        Alt+T { spawn "bash" "/home/shaonix/.local/bin/show-datetime.sh"; }
        Alt+S { spawn "bash" "/home/shaonix/.local/bin/system-status.sh"; }
        Alt+N { spawn "bash" "/home/shaonix/.local/bin/network-status.sh"; }
        Alt+A { spawn "bash" "/home/shaonix/.local/bin/audio-info.sh"; }
        Alt+K { spawn "bash" "/home/shaonix/.local/bin/keybinds-cheatsheet.sh"; }

        // ── Tools ─────────────────────────────────────────────────────
        Mod+O { spawn "bash" "/home/shaonix/.local/bin/ocr-extract.sh"; }
        Mod+P { spawn "bash" "/home/shaonix/.local/bin/color-pick.sh"; }

        // ── Session ───────────────────────────────────────────────────
        Mod+Shift+X { spawn "hyprlock"; }
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
        outer_color       = "rgb(458588)";
        inner_color       = "rgb(FDF6E3)";
        font_color        = "rgb(000000)";
        placeholder_text  = "<i>Password...</i>";
        shadow_passes     = 2;
        halign            = "center";
        valign            = "center";
      }];

      label = [{
        text        = "$TIME";
        color       = "rgba(000000ff)";
        font_size   = 52;
        font_family = "JetBrainsMono Nerd Font";
        position    = "0, 80";
        halign      = "center";
        valign      = "center";
      }];
    };
  };

  services.mako = {
  enable = true;
  settings = {

      background-color = "#FDF6E3";
text-color       = "#000000";
border-color     = "#458588";

      
    anchor           = "top-center";
    margin           = "10";
    padding          = "10,16";
    width            = 340;
    height           = 120;
    border-size      = 2;
    border-radius    = 8;
    default-timeout  = 4000;
    layer            = "overlay";
    font = lib.mkForce "JetBrainsMono Nerd Font 12";
  };
};
}
