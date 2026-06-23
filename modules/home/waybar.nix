{ theme, themeNoHash, ... }:
{
  home.file.".config/waybar/config.jsonc" = {
    text = ''
      {
        "reload_style_on_change": true,
        "layer": "top",
        "position": "top",
        "spacing": 0,
        "height": 13,
        "modules-left": ["custom/logo", "niri/window"],
        "modules-center": ["niri/workspaces"],
        "modules-right": [
          "clock",
          "custom/nightlight",
          "custom/media",
          "custom/screenshot",
          "group/tray-expander",
          "bluetooth",
          "network",
          "pulseaudio"
        ],
        "niri/window": {
          "format": "{app_id}",
          "max-length": 13,
          "separate-outputs": true,
          "rewrite": {
            "google-chrome": " Chrome",
            "tor-browser": " Tor",
            "kitty": " Terminal",
            "nvim": " Neovim",
            "inkscape": " Inkscape",
            "evince": "󰈦 PDF Viewer",
            "mpv": " MPV Player",
            "imv": "󰋩 Image Viewer",
            "org.keepassxc.KeePassXC": " KeePassXC",
            "btop": "󰍛 Btop",
            "yazi": "󰇥 Yazi",
            "typst": "󰏫 Typst",
            "org.gnome.Nautilus": "󰉋 Files",
            "org.pulseaudio.pavucontrol": "󰓃 Audio",
            "nm-connection-editor": "󰤨 Network",
            "fastfetch": "󱄄 Fetch",
            "nh": "󱄄 Nix Helper",
            "^$": "󰖳 Desktop",
            "(.*)": "$1"
          }
        },
        "clock": {
          "format": "{:%A %H:%M}",
          "format-alt": "{:%d %B W%V %Y}",
          "tooltip": false
        },
        "custom/logo": {
          "format": "",
          "tooltip": false
        },
        "custom/media": {
          "format": "{}",
          "return-type": "json",
          "exec": "playerctl -a metadata --format '{\"text\": \"{{emoji(status)}} {{title}}\", \"tooltip\": \"{{playerName}}: {{title}} — {{artist}}\", \"class\": \"{{status}}\"}' -F 2>/dev/null",
          "on-click": "playerctl play-pause",
          "max-length": 30
        },
        "custom/nightlight": {
          "format": "{}",
          "exec": "if pgrep -x wlsunset > /dev/null; then echo '󰛨'; else echo '󰛩'; fi",
          "interval": 2,
          "on-click": "bash ~/.local/bin/wlsunset-toggle.sh",
          "signal": 8,
          "tooltip-format": "Night light toggle"
        },
        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "󰝟 muted",
          "scroll-step": 5,
          "on-click": "kitty -e wiremix",
          "on-click-right": "pamixer -t",
          "tooltip-format": "Volume: {volume}%",
          "format-icons": {
            "headphone": "",
            "headset": "",
            "default": ["", "", ""]
          }
        },
        "network": {
          "format-icons": ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
          "format": "{icon}",
          "format-wifi": "{icon}",
          "format-ethernet": "󰀂",
          "format-disconnected": "󰤮",
          "tooltip-format-wifi": "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
          "tooltip-format-ethernet": "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
          "tooltip-format-disconnected": "Disconnected",
          "interval": 3,
          "on-click": "kitty -e nmtui"
        },
        "bluetooth": {
          "format": "",
          "format-off": "󰂲",
          "format-disabled": "󰂲",
          "format-connected": "󰂱",
          "format-no-controller": "",
          "tooltip-format": "Devices connected: {num_connections}",
          "on-click": "blueman-manager"
        },
        "custom/screenshot": {
          "format": "󰄀",
          "tooltip-format": "Screenshot\nLeft: region\nRight: fullscreen",
          "on-click": "bash ~/.local/bin/screenshot-capture-wayland.sh region",
          "on-click-right": "bash ~/.local/bin/screenshot-capture-wayland.sh"
        },
        "group/tray-expander": {
          "orientation": "inherit",
          "drawer": {
            "transition-duration": 600,
            "children-class": "tray-group-item"
          },
          "modules": ["custom/expand-icon", "tray"]
        },
        "custom/expand-icon": {
          "format": "",
          "tooltip": false
        },
        "tray": {
          "icon-size": 12,
          "spacing": 17
        }
      }
    '';
  };

  home.file.".config/waybar/style.css" = {
    text = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        font-weight: 600;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: linear-gradient(to bottom, #2f2f2f, #2a2a2a);
        border-bottom: none;
        color: #ebdbb2;
      }

      .modules-left  { margin-left:  3px; }
      .modules-right { margin-right: 4px;  }

      /* ── shared block base ── */
      #clock,
      #custom-nightlight,
      #custom-media,
      #custom-screenshot,
      #custom-expand-icon,
      #tray,
      #bluetooth,
      #network,
      #pulseaudio {
        margin: 3px 2px;
        padding: 0 11px;
        border-radius: 6px;
        min-height: 13px;
        color: #282828;
      }

      /* ── logo ── */
      #custom-logo {
        background: linear-gradient(to bottom, #83a598, #6f8f8a);
        color: #282828;
        font-size: 18px;
        padding: 0 10px;
        border-radius: 6px;
        min-height: 29px;
        margin: 3px 6px 3px 3px;
      }

      /* ── window title ── */
      #window {
        color: #ebdbb2;
        font-weight: 600;
        padding: 0 8px;
      }

      /* ── workspaces ── */
      #workspaces button {
        all: initial;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        font-weight: 600;
        padding: 0 11px;
        margin: 3px 2px;
        min-width: 9px;
        min-height: 13px;
        border-radius: 6px;
        background: linear-gradient(to bottom, #4f4844, #3f3835);
        color: #ebdbb2;
      }
      #workspaces button.active {
        background: linear-gradient(to bottom, #83a598, #6f8f8a);
        color: #282828;
      }
      #workspaces button.nonempty {
        background: linear-gradient(to bottom, #675e57, #514a44);
        color: #ebdbb2;
      }
      #workspaces button.urgent {
        background: linear-gradient(to bottom, #cc241d, #9d0006);
        color: #ebdbb2;
      }
      #workspaces button:hover {
        background: linear-gradient(to bottom, #675e57, #514a44);
      }

      /* ── clock — tan, hidden until hover ── */
      #clock {
        background: linear-gradient(to bottom, #d5c4a1, #b8a785);
        font-weight: 700;
        min-width: 45px;
        opacity: 0;
        transition: opacity 0.5s ease-in-out;
        transition-delay: 3s;
      }
      #clock:hover {
        opacity: 1;
        transition-delay: 0s;
        transition: opacity 0.1s ease-in-out;
      }

      /* ── nightlight — warm amber (perfect fit!) ── */
      #custom-nightlight {
        background: linear-gradient(to bottom, #e0af4a, #c49632);
      }

      /* ── media — green ── */
      #custom-media {
        background: linear-gradient(to bottom, #97b87a, #7d9e62);
      }
      #custom-media.Paused {
        background: linear-gradient(to bottom, #4f4844, #3f3835);
        color: #ebdbb2;
      }

      /* ── screenshot — teal ── */
      #custom-screenshot {
        background: linear-gradient(to bottom, #83a598, #6f8f8a);
      }

      /* ── tray expander — dark ── */
      #custom-expand-icon {
        background: linear-gradient(to bottom, #4f4844, #3f3835);
        color: #ebdbb2;
      }
      #tray {
        background: linear-gradient(to bottom, #4f4844, #3f3835);
        color: #ebdbb2;
      }
      .tray-group-item { margin: 0 2px; }

      /* ── bluetooth — teal ── */
      #bluetooth {
        background: linear-gradient(to bottom, #83a598, #6f8f8a);
      }
      #bluetooth.off,
      #bluetooth.disabled {
        background: linear-gradient(to bottom, #4f4844, #3f3835);
        color: #ebdbb2;
      }

      /* ── network — green ── */
      #network {
        background: linear-gradient(to bottom, #97b87a, #7d9e62);
      }
      #network.disconnected {
        background: linear-gradient(to bottom, #cc241d, #9d0006);
        color: #ebdbb2;
      }

      /* ── pulseaudio — tan ── */
      #pulseaudio {
        background: linear-gradient(to bottom, #d5c4a1, #b8a785);
      }
      #pulseaudio.muted {
        background: linear-gradient(to bottom, #cc241d, #9d0006);
        color: #ebdbb2;
      }

      /* ── tooltips ── */
      tooltip {
        background-color: #282828;
        border: 1px solid #83a598;
        padding: 2px;
      }
      tooltip label { color: #ebdbb2; }
    '';
  };
}
