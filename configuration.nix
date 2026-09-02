{ config, pkgs, lib, ... }:

let
  theme-name         = "Gruvbox-Green-Light-Medium";
  theme-package      = pkgs.gruvbox-gtk-theme.override {
    colorVariants  = [ "light" ];
    sizeVariants   = [ "standard" ];
    themeVariants  = [ "green" ];
    tweakVariants  = [ "medium" "macos" ];
  };
  icon-theme-package = pkgs.gruvbox-plus-icons;
  icon-theme-name    = "Gruvbox-Plus-Light";
  gtksettings        = ''
    [Settings]
    gtk-icon-theme-name = ${icon-theme-name}
    gtk-theme-name = ${theme-name}
  '';
in
{
  # ── Boot ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules                   = [ "i2c-dev" ];

  # ── Networking ───────────────────────────────────────────────────────
  networking.hostName              = "shaonix";
  networking.networkmanager.enable = true;
  networking.firewall.enable       = true;

  # ── Locale / Time ────────────────────────────────────────────────────
  time.timeZone      = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # ── Input method (fcitx5 — system-level) ────────────────────────────
  i18n.inputMethod = {
    type   = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-openbangla-keyboard
      fcitx5-gtk
    ];
  };

  # ── Keyboard ─────────────────────────────────────────────────────────
  services.xserver.xkb = {
    layout  = "us";
  };

  # ── Users ─────────────────────────────────────────────────────────────
  users.users.shaonix = {
    isNormalUser = true;
    description  = "shaonix";
    extraGroups  = [ "networkmanager" "wheel" "video" "input" "storage" "i2c" ];
    shell        = pkgs.bash;
  };

  # ── Security ─────────────────────────────────────────────────────────
  security.pam.services.hyprlock = {};
  security.polkit.enable         = true;
  security.rtkit.enable          = true;

  # ── Hardware ─────────────────────────────────────────────────────────
  hardware.graphics = {
    enable        = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable                = true;

  # ── Audio (PipeWire) ─────────────────────────────────────────────────
  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };
  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "monitor.alsa.rules" = [{
      matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
      actions  = { update-props = { "priority.session" = 2000; }; };
    }];
  };

  # ── Display / Wayland services ────────────────────────────────────────
  programs.niri.enable     = true;
  programs.xwayland.enable = true;

  xdg.portal = {
    enable        = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default                                   = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast"  = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot"  = [ "gnome" ];
    };
  };

  # ── Greeter ───────────────────────────────────────────────────────────
  services.greetd = {
    enable   = true;
    settings = {
      default_session = {
        user    = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
      };
    };
  };

  # ── Desktop services ─────────────────────────────────────────────────
  services.gvfs.enable                = true;
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable             = true;

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    iosevka
  ];
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Noto Sans" "Noto Sans Bengali" ];
      serif     = [ "Noto Serif" "Noto Serif Bengali" ];
    };
  };

  # ── Swap ─────────────────────────────────────────────────────────────
  swapDevices = [{
    device   = "/var/lib/swapfile";
    size     = 8 * 1024;    # 8 GiB in MiB
    priority = 0;            # lower than zram (priority 5) — overflow only
  }];
  zramSwap.enable = true;

  # ── GTK / theming (system-wide) ──────────────────────────────────────
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = gtksettings;
    "xdg/gtk-4.0/settings.ini".text = gtksettings;
  };
  environment.variables.GTK_THEME    = theme-name;
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";

  programs.dconf = {
    enable = lib.mkDefault true;
    profiles.user.databases = [{
      lockAll  = false;
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme    = theme-name;
          icon-theme   = icon-theme-name;
          color-scheme = "prefer-light";
        };
      };
    }];
  };

  # ── Session environment ───────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL                     = "1";
    XDG_CURRENT_DESKTOP                = "niri:GNOME";
    XDG_SESSION_TYPE                   = "wayland";
    XDG_SESSION_DESKTOP                = "niri";
    QT_QPA_PLATFORM                    = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
  };

  # ── System packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # GTK theming
    theme-package
    icon-theme-package
    gtk3
    gtk4
    adwaita-qt

    # Core desktop
    nautilus
    adwaita-icon-theme
    git
    google-chrome
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland

    # Wayland utilities
    swaybg
    mako
    wl-clipboard
    cliphist
    wl-clip-persist

    # Audio
    wiremix
    wireplumber
    pulseaudio

    # Image / screen tools
    imagemagick
    slurp
    grim

    # System tools
    wlsunset
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    udiskie
    p7zip
    keepassxc
    zathura
    ripgrep
    yazi
    libnotify
    tesseract
  ];

  # ── Home Manager Integration ──────────────────────────────────────────
  home-manager.users.shaonix = {
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;

    # Session variables (user-level)
    systemd.user.sessionVariables = {
      QT_IM_MODULE                       = "fcitx";
      XMODIFIERS                         = "@im=fcitx";
      GDK_BACKEND                        = "wayland,x11";
    };

    # GTK (user-level)
    gtk = {
      enable    = true;
      iconTheme = {
        name    = "Gruvbox-Plus-Light";
        package = pkgs.gruvbox-plus-icons;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 0;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 0;
    };

    # Qt (user-level)
    qt = {
      enable             = true;
      platformTheme.name = lib.mkForce "gtk";
      style.name         = lib.mkForce "adwaita";
    };

    # XDG MIME / desktop entries
    xdg.desktopEntries.helix = {
      name        = "Helix";
      genericName = "Text Editor";
      exec        = "alacritty -e hx %F";
      terminal    = false;
      categories  = [ "Utility" "TextEditor" ];
      mimeType    = [
        "text/plain" "text/x-nix" "text/markdown"
        "application/json" "text/x-shellscript" "text/x-org"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory"                    = [ "org.gnome.Nautilus.desktop" ];
        "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
        "text/plain"                         = [ "helix.desktop" ];
        "text/x-nix"                         = [ "helix.desktop" ];
        "text/markdown"                      = [ "helix.desktop" ];
        "application/json"                   = [ "helix.desktop" ];
        "text/x-shellscript"                 = [ "helix.desktop" ];
        "text/x-org"                         = [ "helix.desktop" ];
        "application/pdf"                    = [ "zathura.desktop" ];
      };
    };

    # Niri WM config
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
          Mod+Return { spawn "alacritty"; }
          Mod+Space  { spawn "fuzzel"; }
          Mod+W      { spawn "bash" "/home/shaonix/.local/bin/wallpaper-cycle.sh"; }
          Mod+B      { spawn "google-chrome-stable"; }
          Mod+V      { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

// ── Windows ───────────────────────────────────────────────────
          Mod+C         { close-window; }
          Mod+F         { maximize-column; }
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
          Mod+Shift+H      { move-column-left; }
          Mod+Shift+J      { move-window-down-or-to-workspace-down; }
          Mod+Shift+K      { move-window-up-or-to-workspace-up; }
          Mod+Shift+L      { move-column-right; }
          Mod+Shift+Left   { move-column-left; }
          Mod+Shift+Down   { move-window-down-or-to-workspace-down; }
          Mod+Shift+Up     { move-window-up-or-to-workspace-up; }
          Mod+Shift+Right  { move-column-right; }
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

// ── Volume ────────────────────────────────────────────────────
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

    # Hyprlock
    programs.hyprlock = {
      enable   = true;
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
          font_family = "Iosevka";
          position    = "0, 80";
          halign      = "center";
          valign      = "center";
        }];
      };
    };

    # Mako notifications
    services.mako = {
      enable   = true;
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
        font             = lib.mkForce "Iosevka 15";
      };
    };

    # Bash

programs.bash = {
      enable    = true;
      initExtra = ''
        set -o vi

        bind '"\C-h": backward-kill-word'
        bind '"\e\C-?": backward-kill-word'
        bind '"\C-l": clear-screen'

        __prompt() {
          local last=$?

          local reset=$'\001\e[0m\002'
          local bold_teal=$'\001\e[1;38;2;69;133;136m\002'
          local pink=$'\001\e[38;2;224;137;161m\002'
          local bold_green=$'\001\e[1;38;2;184;187;38m\002'
          local bold_red=$'\001\e[1;38;2;204;51;51m\002'
          local bold_cyan=$'\001\e[1;38;2;46;139;132m\002'

          local short_pwd
          short_pwd=$(
            pwd | sed "s|$HOME|~|" | awk -F'/' '{
              out = ""
              for (i = 1; i <= NF; i++) {
                if (i == NF) {
                  out = out (out == "" ? "" : "/") $i
                } else if ($i == "~") {
                  out = "~"
                } else if ($i == "") {
                  true
                } else {
                  out = out (out == "" ? "" : "/") substr($i, 1, 3)
                }
              }
              print out
            }'
          )

          PS1="''${bold_teal} ''${reset}"

          if [ -n "''${IN_NIX_SHELL}" ]; then
            PS1+="''${bold_cyan}❄ ''${reset}"
          fi

          PS1+="''${bold_teal}''${short_pwd}''${reset}"

          local branch
          branch=$(git branch --show-current 2>/dev/null)
          if [ -n "''${branch}" ]; then
            PS1+="''${pink}  ''${branch}''${reset}"
          fi

          PS1+=$'\n'

          if [ "''${last}" -eq 0 ]; then
            PS1+="''${bold_green}❯ ''${reset}"
          else
            PS1+="''${bold_red}❯ ''${reset}"
          fi
        }

        PROMPT_COMMAND=__prompt
      '';
      shellAliases = {
        ls  = "eza -l -a -a -h";
        ll  = "eza -l -a -a -h";
        vim = "hx";
      };
    };

    

    programs.eza = {
      enable                = true;
      enableBashIntegration = true;
    };

    # Helix editor
    programs.helix = {
      enable        = true;
      defaultEditor = true;

      settings = {
        theme  = "solarized_light";
        editor = {
          line-number        = "relative";
          mouse              = true;
          clipboard-provider = "wayland";
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          lsp = {
            display-messages     = true;
            display-inlay-hints  = true;
          };
          statusline = {
            left   = [ "mode" "spinner" ];
            center = [ "file-name" "file-modification-indicator" ];
            right  = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
            mode   = {
              normal = "🟢 NORMAL";
              insert = "🔴 INSERT";
              select = "🔵 SELECT";
            };
          };
        };
        keys = {
          normal = {
            "C-c" = "yank_main_selection_to_clipboard";
            "C-v" = "paste_clipboard_after";
          };
          select = {
            "C-c" = "yank_main_selection_to_clipboard";
          };
          insert = {
            "C-v" = "paste_clipboard_after";
          };
        };
      };

      extraPackages = [
        pkgs.nixd
        pkgs.nixfmt
      ];

      languages = {
        language = [{
          name         = "nix";
          auto-format  = true;
          formatter    = { command = "${pkgs.nixfmt}/bin/nixfmt"; };
          language-servers = [ "nixd" ];
        }];
        language-server = {
          nixd = { command = "${pkgs.nixd}/bin/nixd"; };
        };
      };
    };

    # Alacritty
    programs.alacritty = {
      enable   = true;
      settings = {
        font = {
          size   = 18;
          normal      = { family = "Iosevka"; style = "Regular"; };
          bold        = { family = "Iosevka"; style = "Bold"; };
          italic      = { family = "Iosevka"; style = "Italic"; };
          bold_italic = { family = "Iosevka"; style = "Bold Italic"; };
        };
        window.padding = { x = 10; y = 10; };
        cursor.style.shape = "Block";
        colors = {
          primary   = { background = "#FDF6E3"; foreground = "#000000"; };
          selection = { text = "#000000"; background = "#D9D3C3"; };
          cursor    = { cursor = "#458588"; };
          normal = {
            black   = "#FDF6E3";
            red     = "#CC3333";
            green   = "#458588";
            yellow  = "#9A7D0A";
            blue    = "#458588";
            magenta = "#e089a1";
            cyan    = "#2E8B84";
            white   = "#000000";
          };
          bright = {
            black   = "#999999";
            red     = "#CC3333";
            green   = "#458588";
            yellow  = "#9A7D0A";
            blue    = "#458588";
            magenta = "#e089a1";
            cyan    = "#2E8B84";
            white   = "#000000";
          };
        };
      };
    };

    # Fuzzel launcher
    programs.fuzzel = {
      enable   = true;
      settings = {
        colors = {
          background     = "FDF6E3ff";
          text           = "000000ff";
          match          = "458588ff";
          selection      = "D9D3C3ff";
          selection-text = "000000ff";
          border         = "458588ff";
        };
        main = {
          font     = lib.mkForce "Iosevka:size=18";
          lines    = 12;
          width    = 45;
          terminal = "alacritty";
        };
        border = {
          width  = 2;
          radius = 6;
        };
      };
    };

    # imv image viewer
    programs.imv = {
      enable   = true;
      settings = {
        options = {
          background                 = "FDF6E3";
          overlay_text_color         = "000000";
          overlay_background_color = "D9D3C3";
          overlay_font               = "Iosevka:15";
        };
        binds = {
          "<Ctrl+p>"       = ''exec lp "$imv_current_file"'';
          "<Ctrl+x>"       = ''exec rm "$imv_current_file"; quit'';
          "<Ctrl+Shift+X>" = ''exec rm "$imv_current_file"; close'';
          "<Ctrl+r>"       = ''exec mogrify -rotate 90 "$imv_current_file"'';
        };
      };
    };

    # MPV
    programs.mpv = {
      enable   = true;
      config   = {
        profile                 = "fast";
        vo                      = "gpu";
        hwdec                   = "vaapi";
        "gpu-api"               = "opengl";
        save-position-on-quit = true;
        osc                     = false;
        border                  = false;
        cursor-autohide         = 1000;
        slang                   = "en,eng,enUS,enGB,enAU,enNZ,enCA,enIE,enZA";
        ytdl-raw-options        = "ignore-config=,sub-langs=\"en.*,^en\",write-subs=,write-auto-subs=";
        sub-visibility          = "yes";
        sub-auto                = "fuzzy";
        sub-font                = "Iosevka";
        sub-font-size           = 33;
        sub-border-size         = 3;
        sub-shadow-offset       = 1;
        sub-pos                 = 98;
        sub-align-y             = "bottom";
        sub-margin-y            = 20;
        osd-font                = "Iosevka";
        osd-font-size           = 28;
      };
      bindings = {
        "l"     = "seek 5";
        "h"     = "seek -5";
        "k"     = "add volume 2";
        "j"     = "add volume -2";
        "f"     = "cycle fullscreen";
        "SPACE" = "cycle pause";
        "s"     = "screenshot";
        "S"     = "cycle sub";
        "v"     = "cycle sub-visibility";
        "]"     = "add speed 0.1";
        "["     = "add speed -0.1";
        "BS"    = "set speed 1.0";
        "q"     = "quit";
        "Q"     = "quit-watch-later";
      };
    };

    # Yazi file manager config
    home.file.".config/yazi/yazi.toml".text = ''
      [mgr]
      show_hidden = true
      [opener]
      edit = [
          { run = 'alacritty -e hx "$@"', orphan = true },
      ]
      open = [
          { run = 'xdg-open "$@"', desc = "Open", for = "unix" },
      ]
      image = [
          { run = 'imv "$@"', orphan = true, for = "unix" },
      ]
      play_audio = [
          { run = 'pkill -q mpv; mpv --force-window --no-resume-playback "$@"', desc = "Play Audio" }
      ]
      open_pdf = [
          { run = 'zathura "$@"', orphan = true, desc = "Open PDF", for = "unix" },
      ]

      [[opener.browser]]
      run = 'google-chrome-stable "$@"'
      orphan = true
      desc = "Open in Chrome"
      for = "unix"

      [open]
      rules = [
          { mime = "audio/*",       use = "play_audio" },
          { mime = "image/*",       use = "image" },
          { mime = "text/*",        use = "edit" },
          { mime = "video/*",       use = [ "open" ] },
          { mime = "application/pdf", use = "open_pdf" },
      ]
      [[open.prepend_rules]]
      mime = "text/html"
      use = "browser"
      [[open.prepend_rules]]
      mime = "application/xhtml+xml"
      use = "browser"
    '';

    home.file.".config/yazi/theme.toml".text = ''
      [mgr]
      cwd               = { fg = "#458588", bold = true }
      hovered           = { fg = "#FDF6E3", bg = "#458588" }
      find_keyword    = { fg = "#458588", bold = true }
      find_position   = { fg = "#C67F3A", bg = "reset", bold = true }
      marker_copied   = { fg = "#458588", bg = "#458588" }
      marker_cut      = { fg = "#CC3333", bg = "#CC3333" }
      marker_selected = { fg = "#458588", bg = "#458588" }
      count_copied    = { fg = "#FDF6E3", bg = "#458588" }
      count_cut       = { fg = "#FDF6E3", bg = "#CC3333" }
      count_selected  = { fg = "#FDF6E3", bg = "#458588" }
      border_symbol   = "│"
      border_style    = { fg = "#999999" }

      [indicator]
      preview = { underline = true }

      [tabs]
      active   = { fg = "#FDF6E3", bg = "#458588", bold = true }
      inactive = { fg = "#8B7355", bg = "#D9D3C3" }

      [status]
      separator_open  = ""
      separator_close = ""
      separator_style = { fg = "#D9D3C3", bg = "#D9D3C3" }
      mode_normal     = { fg = "#FDF6E3", bg = "#458588", bold = true }
      mode_select     = { fg = "#FDF6E3", bg = "#458588", bold = true }
      mode_unset      = { fg = "#FDF6E3", bg = "#458588", bold = true }
      progress_label  = { fg = "#000000", bold = true }
      progress_normal = { fg = "#458588", bg = "#D9D3C3" }
      progress_error  = { fg = "#CC3333", bg = "#D9D3C3" }
      permissions_t   = { fg = "#C67F3A" }
      permissions_r   = { fg = "#458588" }
      permissions_w   = { fg = "#CC3333" }
      permissions_x   = { fg = "#458588" }
      permissions_s   = { fg = "#999999" }

      [input]
      border   = { fg = "#C67F3A" }
      title    = {}
      value    = {}
      selected = { reversed = true }

      [select]
      border   = { fg = "#C67F3A" }
      active   = { fg = "#458588", bold = true }
      inactive = {}

      [tasks]
      border  = { fg = "#C67F3A" }
      title   = {}
      hovered = { underline = true }

      [which]
      cols              = 3
      mask              = { bg = "#D9D3C3" }
      cand              = { fg = "#458588" }
      rest              = { fg = "#999999" }
      desc              = { fg = "#000000" }
      separator         = "  "
      separator_style = { fg = "#999999" }

      [notify]
      title_info  = { fg = "#458588" }
      title_warn  = { fg = "#9A7D0A" }
      title_error = { fg = "#CC3333" }

      [filetype]
      rules = [
        { mime = "image/*",       fg = "#458588" },
        { mime = "video/*",       fg = "#C67F3A" },
        { mime = "audio/*",       fg = "#458588" },
        { mime = "text/*",        fg = "#000000" },
        { mime = "inode/directory", fg = "#C67F3A", bold = true },
        { mime = "*.nix",         fg = "#458588" },
        { mime = "*.rs",          fg = "#C67F3A" },
        { mime = "*.py",          fg = "#9A7D0A" },
        { mime = "*.sh",          fg = "#458588" },
        { mime = "*.md",          fg = "#000000" },
        { mime = "*.toml",        fg = "#C67F3A" },
        { mime = "*.json",        fg = "#9A7D0A" },
      ]
    '';

    # Shell scripts (.local/bin)
    home.file.".local/bin/screenshot-capture-wayland.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        SCREENSHOT_DIR="$HOME/dirrr"
        LOCKFILE="$HOME/.ss_counter.lock"
        mkdir -p "$SCREENSHOT_DIR"
        exec 200>"$LOCKFILE"
        flock 200
        n=1
        while [ -f "$SCREENSHOT_DIR/ss$n.png" ]; do
          n=$((n + 1))
        done
        if [ "$1" = "region" ]; then
          grim -g "$(slurp)" "$SCREENSHOT_DIR/ss$n.png" || exit 0
        else
          grim "$SCREENSHOT_DIR/ss$n.png"
        fi
        wl-copy < "$SCREENSHOT_DIR/ss$n.png"
        notify-send -i "$SCREENSHOT_DIR/ss$n.png" "📸 Screenshot" "Saved: ss$n.png — copied to clipboard" -t 3000
      '';
    };

    home.file.".local/bin/wlsunset-adjust.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        STEP=200
        STORE="$HOME/.wlsunset_temp"
        [ -f "$STORE" ] && CURRENT=$(cat "$STORE") || CURRENT=3000

        case "$1" in
          up)   NEW=$((CURRENT + STEP)) ;;
          down) NEW=$((CURRENT - STEP)) ;;
          *)    NEW=$CURRENT ;;
        esac

        [ "$NEW" -lt 1000 ] && NEW=1000
        [ "$NEW" -gt 6500 ] && NEW=6500

        echo "$NEW" > "$STORE"
        pkill wlsunset 2>/dev/null
        sleep 0.2
        setsid wlsunset -t "$NEW" -T $((NEW + 1)) -l 90 -L 0 >/dev/null 2>&1 &
        notify-send "🌡 Colour Temp" "''${NEW}K" -t 1200
      '';
    };

    home.file.".local/bin/volume-control.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        timeout=5
        while [ $timeout -gt 0 ]; do
          pactl info &>/dev/null && break
          sleep 0.5
          timeout=$((timeout - 1))
        done

        case "$1" in
          up)   pactl set-sink-volume @DEFAULT_SINK@ +2% ;;
          down) pactl set-sink-volume @DEFAULT_SINK@ -2% ;;
          mute) pactl set-sink-mute  @DEFAULT_SINK@ toggle ;;
        esac

        MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -c "yes")
        VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

        if [ "$MUTED" -gt 0 ]; then
          notify-send -h string:x-canonical-private-synchronous:volume \
            "🔇 Muted" "" -t 1000
        else
          notify-send -h string:x-canonical-private-synchronous:volume \
            "🔊 Volume" "$VOL" -t 1000
        fi
      '';
    };
 



home.file.".local/bin/system-status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      MEM=$(free -h | awk '/^Mem:/ {print $3"/"$2}')
      DISK=$(df -h / | awk 'NR==2{print $3"/"$2" ("$5")"}')
      UPTIME=$(uptime -p | sed 's/up //')
      CPU_LOAD=$(uptime | grep -oP 'load average: \K[^,]+')
      CPU_TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | \
        awk '{sum+=$1; n++} END {if(n>0) printf "%.0f°C", sum/n/1000; else print "n/a"}')
      notify-send "💻 System" \
        "RAM:    $MEM
      Disk:   $DISK
      Load:   $CPU_LOAD
      Temp:   $CPU_TEMP
      Uptime: $UPTIME" -t 6000
    '';
  };

  home.file.".local/bin/wallpaper-cycle.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      WALLDIR="$HOME/dirrr/wallpapers"
      STORE="$HOME/.current_wallpaper"

      mapfile -t WALLS < <(find "$WALLDIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

      if [ ''${#WALLS[@]} -eq 0 ]; then
        notify-send "🖼 Wallpaper" "No images found in ~/dirrr/wallpapers" -t 2000
        exit 1
      fi

      CURRENT=$(cat "$STORE" 2>/dev/null || echo "-1")
      NEXT=$(( (CURRENT + 1) % ''${#WALLS[@]} ))
      echo "$NEXT" > "$STORE"

      WALL="''${WALLS[$NEXT]}"
      pkill swaybg 2>/dev/null
      sleep 0.1
      swaybg -i "$WALL" -m fill &
      notify-send "🖼 Wallpaper" "$(basename "$WALL")" -t 1500
    '';
  };

  home.file.".local/bin/network-status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      IFACE=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\S+' | head -1)
      IP=$(ip addr show "$IFACE" 2>/dev/null | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | head -1)
      SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
      PING=$(ping -c1 -W1 8.8.8.8 2>/dev/null | grep -oP 'time=\K[\d.]+' | head -1)

      if [ -n "$SSID" ]; then
        notify-send "🌐 Network" "WiFi: $SSID
      IP:   ''${IP:-unknown}
      Ping: ''${PING:-timeout}ms" -t 4000
      elif [ -n "$IP" ]; then
        notify-send "🌐 Network" "Ethernet: $IP
      Ping: ''${PING:-timeout}ms" -t 4000
      else
        notify-send "🌐 Network" "No connection" -t 4000
      fi
    '';
  };

  home.file.".local/bin/audio-info.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      SINK=$(pactl info | grep "Default Sink" | cut -d: -f2 | xargs | sed 's/.*\.//')
      VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
      MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(yes|no)')
      SOURCE=$(pactl info | grep "Default Source" | cut -d: -f2 | xargs | sed 's/.*\.//')
      notify-send "🔊 Audio" "Out: $SINK
      Vol: $VOL (muted: $MUTED)
      In:  $SOURCE" -t 4000
    '';
  };

  home.file.".local/bin/show-datetime.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      DATE=$(date "+%A, %d %B %Y")
      TIME=$(date "+%H:%M:%S")
      WEEK=$(date "+Week %V")
      notify-send "🕐 Time" "$TIME
      $DATE
      $WEEK" -t 4000
    '';
  };

  home.file.".local/bin/ocr-extract.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      TMPIMG=$(mktemp /tmp/ocr-XXXXXX.png)
      grim -g "$(slurp)" "$TMPIMG" || { rm -f "$TMPIMG"; exit 0; }
      TEXT=$(tesseract "$TMPIMG" stdout 2>/dev/null | tr -d '\f')
      rm -f "$TMPIMG"
      if [ -n "$TEXT" ]; then
        echo "$TEXT" | wl-copy
        notify-send "📋 OCR" "Text copied to clipboard" -t 2000
      else
        notify-send "📋 OCR" "No text found" -t 2000
      fi
    '';
  };

  home.file.".local/bin/color-pick.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      TMPIMG=$(mktemp /tmp/colorpick-XXXXXX.png)
      grim -g "$(slurp -p)" "$TMPIMG" 2>/dev/null || { rm -f "$TMPIMG"; exit 0; }
      HEX=$(convert "$TMPIMG" -format "#%[hex:u.p{0,0}]" info: 2>/dev/null | head -c 7)
      rm -f "$TMPIMG"
      if [ -n "$HEX" ]; then
        echo "$HEX" | wl-copy
        notify-send "🎨 Colour" "$HEX — copied to clipboard" -t 2500
      fi
    '';
  };

  home.file.".local/bin/keybinds-cheatsheet.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      CHEATSHEET=$(cat << 'KEYS'
      ── Apps ──────────────────────────────
      Mod+Return          Terminal (Alacritty)
      Mod+Space           App launcher (fuzzel)
      Mod+B               Google Chrome
      Mod+V               Clipboard history
      ── Windows ───────────────────────────
      Mod+C               Close window
      Mod+F               Maximize column
      Mod+Shift+Space     Toggle floating
      ── Focus ─────────────────────────────
      Mod+H/J/K/L         Focus left/down/up/right
      Mod+Arrows          Focus (arrow keys)
      ── Move ──────────────────────────────
      Mod+Shift+H/J/K/L   Move window
      Mod+Shift+Arrows    Move window
      Mod+Shift+,/.       Move to monitor left/right
      ── Workspaces ────────────────────────
      Mod+1-9             Switch workspace
      Mod+Shift+1-9       Move window to workspace
      ── Screenshot ────────────────────────
      Mod+Z               Region screenshot
      Mod+Shift+Z         Full screenshot
      ── Audio ─────────────────────────────
      Mod+F1              Mute toggle
      Mod+F2              Volume -5%
      Mod+F3              Volume +5%
      ── Colour temp ───────────────────────
      Mod+Alt+Up          Warmer (+200K)
      Mod+Alt+Down        Cooler (-200K)
      Mod+Shift+W         Toggle night mode
      ── Info popups ───────────────────────
      Alt+T               Date & time
      Alt+S               System status
      Alt+N               Network status
      Alt+A               Audio info
      Alt+K               THIS cheatsheet
      ── Language ──────────────────────────
      Ctrl+Space          Change keyboard layout
      ── Screen ────────────────────────────
      Mod+O               OCR (copy text from screen)
      Mod+P               Colour picker
      ── Session ───────────────────────────
      Mod+Shift+X         Lock screen (hyprlock)
      Mod+Shift+E         Quit niri
      KEYS
      )
      echo "$CHEATSHEET" | fuzzel --dmenu \
        --prompt="  Keybinds — Esc to close  " \
        --lines=22 \
        --width=44 \
        --no-exit-on-keyboard-focus-loss
    '';
  };
};

  # ── Nix settings ─────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree          = true;

  system.stateVersion = "26.05";
}
