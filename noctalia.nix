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
order = [ "main" ]

    [bar.main]
    background_opacity = 0.54999998770654202
    center = [ "workspaces" ]
    end = [ "clock", "tray", "wallpaper", "notifications", "network", "clipboard", "volume", "battery", "session" ]
    font_family = "JetBrainsMono NF ExtraBold"
    margin_edge = 0
    margin_ends = 0
    position = "top"
    radius = 0
    reserve_space = true
    start = [ "launcher", "media" ]
    thickness = 34

        [[bar.main.capsule_group]]
        enabled = true
        fill = "surface_variant"
        id = "g1"
        members = [ "battery", "clipboard" ]
        opacity = 1.0
        padding = 6.0

[desktop_widgets]
schema_version = 2
widget_order = []

    [desktop_widgets.grid]
    cell_size = 16
    major_interval = 4
    visible = true

    [desktop_widgets.widget]

[dock]
show_dots = true

[hot_corners]
enabled = true

    [hot_corners.top_right]
    action = "control_center"

[lockscreen]
fingerprint = false

[lockscreen_widgets]
enabled = false
schema_version = 2
widget_order = [ "lockscreen-login-box@HDMI-A-2" ]

    [lockscreen_widgets.grid]
    cell_size = 16
    major_interval = 4
    visible = true

    [lockscreen_widgets.widget."lockscreen-login-box@HDMI-A-2"]
    box_height = 70.0
    box_width = 400.0
    cx = 640.0
    cy = 905.0
    output = "HDMI-A-2"
    rotation = 0.0
    type = "login_box"

        [lockscreen_widgets.widget."lockscreen-login-box@HDMI-A-2".settings]
        background_color = "surface_variant"
        background_opacity = 0.88
        background_radius = 12.0
        center_password_text = false
        input_opacity = 1.0
        input_radius = 6.0
        show_caps_lock = true
        show_keyboard_layout = true
        show_login_button = true

[notification]
enable_daemon = true
max_popups = 5
position = "top_center"

[osd.kinds]
dnd = false

[plugins]
enabled = [ "noctalia/wallhaven" ]

[shell]
app_icon_colorize = true
font_family = "JetBrainsMono NF ExtraBold"
screen_time_enabled = true

[theme]
builtin = "Gruvbox"
mode = "light"
source = "builtin"
wallpaper_scheme = "m3-content"

[wallpaper]
directory = "/home/az/dirrr/wallpapers"
directory_dark = "/home/az/dirrr/wallpapers"
directory_light = "/home/az/dirrr/wallpapers"

    [wallpaper.automation]
    order = "alphabetical"

    [wallpaper.default]
    path = "/home/az/dirrr/wallpapers/wallhaven-zxqkdy.jpg"

    [wallpaper.last]
    path = "/home/az/dirrr/wallpapers/wallhaven-zxqkdy.jpg"

    [wallpaper.monitors.HDMI-A-2]
    path = "/home/az/dirrr/wallpapers/wallhaven-zxqkdy.jpg"

    [[wallpaper.favorite]]
    builtin_palette = "Ayu"
    palette_source = "builtin"
    path = "/home/az/dirrr/wallpapers/wallhaven-yq2rk7.png"
    theme_mode = "dark"

[widget.wallhaven]
enabled = false
  '';

  # Mutable: ensure settings.toml directory exists, but DON'T lock the file
  # Noctalia GUI writes here freely; survives rebuilds
  home.file.".local/state/noctalia/.keep".text = "";
}
