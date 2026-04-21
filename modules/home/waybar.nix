{ theme, themeNoHash, ... }:
{
  home.file.".config/waybar/config.jsonc" = {
    text = ''
      {
        "reload_style_on_change": true,
        "layer": "top",
        "position": "top",
        "spacing": 0,
        "height": 16,
        "modules-left": ["custom/logo", "niri/workspaces"],
        "modules-center": ["niri/window"],
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
  "max-length": 35,
  "separate-outputs": true,
  "rewrite": {
    # Browsers
    "google-chrome": " Chrome",
    "tor-browser": " Tor",
    
    # Terminal & Editors
    "kitty": " Terminal",
    "nvim": " Neovim",
    "inkscape": " Inkscape",
    "evince": "󰈦 PDF Viewer",
    
    # Media & Images
    "mpv": " MPV Player",
    "imv": "󰋩 Image Viewer",
    
    # Tools & System
    "org.keepassxc.KeePassXC": " KeePassXC",
    "btop": "󰍛 Btop",
    "yazi": "󰇥 Yazi",
    "typst": "󰏫 Typst",
    "org.gnome.Nautilus": "󰉋 Files",
    "org.pulseaudio.pavucontrol": "󰓃 Audio",
    "nm-connection-editor": "󰤨 Network",
    
    # Scripts / Utils
    "fastfetch": "󱄄 Fetch",
    "nh": "󱄄 Nix Helper",
    
    # Catch-all for anything else
    "^$": "󰖳 Desktop",
    "(.*)": "󱂬 $1"
  }
},


       "clock": {
          "format": "{:%A %H:%M}",
          "format-alt": "{:%d %B W%V %Y}",
          "tooltip": false
        },
        "cpu": {
          "interval": 5,
          "format": "󰍛 {usage}%",
          "tooltip": true,
          "on-click": "kitty -e btop"
        },
        "custom/logo": {
          "format": "",
          "tooltip": false
        },
        "memory": {
          "interval": 5,
          "format": "󰾆 {percentage}%",
          "tooltip-format": "{used:0.1f}G / {total:0.1f}G"
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
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 13px;
        font-weight: 600;
        min-height: 0;
        border: none;
        border-radius: 0;
      }
      window#waybar {
        background-color: ${theme.base00};
        color: ${theme.base06};
        border-bottom: 2px solid ${theme.base0D};
      }
      .modules-left  { margin-left:  3px; }
      .modules-right { margin-right: 8px; }
      #workspaces button {
        all: initial;
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 13px;
        font-weight: 600;
        padding: 0 4px;
        margin: 0 1.5px;
        min-width: 9px;
        color: ${theme.base04};
        opacity: 0.6;
      }

      #window {
    color: ${theme.base0E};
    font-weight: 600;
}


      #custom-logo {
        color: ${theme.base0D};
        font-size: 18px;
        margin-left: 3px;
        margin-right: 10px;
      }
      #workspaces button.active {
        color: ${theme.base00};
        background-color: ${theme.base0B};
        opacity: 1.0;
      }
      #workspaces button.nonempty {
        color: ${theme.base0A};
        opacity: 1.0;
      }
      #workspaces button.urgent {
        color: ${theme.base07};
        background-color: ${theme.base08};
        opacity: 1.0;
      }


    #clock {
        color: ${theme.base06};
        font-weight: 700;
        margin-right: 10px; /* Space between clock and nightlight */
        
        opacity: 0;
        /* Smaller width since it's in a list of icons now */
        min-width: 45px; 
        
        transition: opacity 0.5s ease-in-out;
        transition-delay: 3s;
      }

      #clock:hover {
        opacity: 1;
        transition-delay: 0s;
        transition: opacity 0.1s ease-in-out;
      }      
      

      #cpu,
      #memory,
      #pulseaudio,
      #network,
      #bluetooth,
      #custom-expand-icon {
        min-width: 12px;
        margin: 0 7.5px;
        color: ${theme.base05};
      }
      #tray               { margin-right: 16px; }
      #bluetooth          { margin-right: 17px; }
      #network            { margin-right: 13px; }
      #custom-expand-icon { margin-right: 18px; }
      .tray-group-item    { margin: 0 4px; }
      #pulseaudio.muted       { color: ${theme.base08}; }
      #network.disconnected   { color: ${theme.base08}; }
      #bluetooth.off          { color: ${theme.base02}; }
      #custom-screenshot {
        margin: 0 7.5px;
        color: ${theme.base06};
      }
      #custom-screenshot:hover { color: ${theme.base0D}; }
      #custom-media             { color: ${theme.base06}; }
      #custom-media.Paused      { color: ${theme.base03}; }
      #custom-nightlight {
        color: ${theme.base06};
        margin: 0 7.5px;
      }
      #custom-nightlight:hover { color: ${theme.base09}; }
      tooltip {
        background-color: ${theme.base01};
        border: 1px solid ${theme.base0D};
        padding: 2px;
      }
      tooltip label { color: ${theme.base07}; }
    '';
  };
}
