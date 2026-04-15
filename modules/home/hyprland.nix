{ config, pkgs, lib, theme, themeNoHash, ... }:
{
  wayland.windowManager.hyprland = {
    enable         = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      monitor = ",preferred,auto,1";

      env = [
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      exec-once = [
        "waybar"
        "mako"
        "udiskie -t"
        "hyprsunset -t 4500"
        "wl-paste --watch cliphist store"
        "wl-clip-persist --clipboard regular"
        "wlr-randr --output HDMI-A-2 --mode 1280x1024@75.004997"
        "swww-daemon"
      ];

      general = {
        gaps_in    = 0;
        gaps_out   = 0;
        border_size = 4;
        "col.active_border"   = "rgba(${themeNoHash.base0B}ff) rgba(${themeNoHash.base0B}ff) 45deg";
        "col.inactive_border" = "rgba(${themeNoHash.base01}ff)";
        layout           = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = false;
          size    = 3;
          passes  = 1;
        };
        active_opacity   = 1.0;
        inactive_opacity = 0.95;
        shadow = {
          enabled      = false;
          range        = 8;
          render_power = 2;
          "color"      = lib.mkForce "rgba(${themeNoHash.base00}bb)";
        };
      };

      input = {
        kb_layout    = "us";
        follow_mouse = 1;
        repeat_rate  = 50;
        repeat_delay = 300;
        touchpad.natural_scroll = false;
      };

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
      };

      animations = {
        enabled = true;
        bezier  = [ "ease, 0.4, 0.0, 0.2, 1.0" ];
        animation = [
          "windows,    1, 4, ease, popin 80%"
          "windowsOut, 1, 4, ease, popin 80%"
          "border,     1, 5, ease"
          "fade,       1, 4, ease"
          "workspaces, 1, 5, ease, slide"
        ];
      };

      misc = {
        disable_hyprland_logo    = true;
        disable_splash_rendering = true;
        force_default_wallpaper  = 0;
      };

      cursor.no_hardware_cursors = false;

      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(File Operation Progress)$"
        "float, title:^(Confirm to replace files)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "float, class:^(imv)$"
        "size 900 600, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
      ];

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, period, exec, cat ~/.config/.emoji | fuzzel --dmenu | awk '{print $1}' | wl-copy && wtype -M ctrl v"
        "$mod, Space, exec, fuzzel"
        "$mod, B, exec, google-chrome-stable --gtk-version=3"
        "$mod, E, exec, thunar"
        "$mod, C, killactive"
        "$mod SHIFT, E, exit"
        "$mod, F, fullscreen"
        "$mod SHIFT, Space, togglefloating"
        "$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
        "$mod SHIFT, X, exec, hyprlock"
        "$mod SHIFT, L, exec, hyprlock"
        "$mod, N, exec, makoctl dismiss"
        "$mod SHIFT, N, exec, makoctl dismiss --all"
        "$mod, Z, exec, bash ~/.local/bin/screenshot-capture-wayland.sh region"
        "$mod SHIFT, Z, exec, bash ~/.local/bin/screenshot-capture-wayland.sh"
        "$mod, W, exec, bash ~/.config/hypr/cycle-wallpaper.sh"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, right, movewindow, r"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, period, movewindow, mon+1"
        "$mod SHIFT, comma, movewindow, mon-1"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -11%"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +11%"
        "$mod, F1, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        "$mod, F2, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "$mod, F3, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "$mod, Page_Up, exec, ddcutil setvcp 10 + 15"
        "$mod, Page_Down, exec, ddcutil setvcp 10 - 15"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd         = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd  = "hyprctl dispatch dpms on";
      };
      listener = [
        { timeout = 300; on-timeout = "loginctl lock-session"; }
        { timeout = 600; on-timeout = "systemctl suspend"; }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor        = true;
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
}
