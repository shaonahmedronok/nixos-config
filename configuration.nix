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
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules                   = [ "i2c-dev" ];

  networking.hostName              = "shaonix";
  networking.networkmanager.enable = true;
  networking.firewall.enable       = true;

  time.timeZone      = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.shaonix = {
    isNormalUser = true;
    description  = "shaonix";
    extraGroups  = [ "networkmanager" "wheel" "video" "input" "storage" "i2c" ];
    shell        = pkgs.bash;
  };

  security.pam.services.hyprlock = {};
  security.polkit.enable         = true;
  security.rtkit.enable          = true;

  hardware.graphics = {
    enable        = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable                = true;

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

  services.greetd = {
    enable   = true;
    settings = {
      default_session = {
        user    = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
      };
    };
  };

  services.gvfs.enable                = true;
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable             = true;

  fonts.packages = with pkgs; [
    iosevka
  ];

  swapDevices = [{
    device   = "/var/lib/swapfile";
    size     = 8 * 1024;    # 8 GiB in MiB
    priority = 0;            # lower than zram (priority 5) — overflow only
  }];
  zramSwap.enable = true;

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

  environment.sessionVariables = {
    NIXOS_OZONE_WL                     = "1";
    XDG_CURRENT_DESKTOP                = "niri:GNOME";
    XDG_SESSION_TYPE                   = "wayland";
    XDG_SESSION_DESKTOP                = "niri";
    QT_QPA_PLATFORM                    = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
  };

  environment.systemPackages = with pkgs; [
    theme-package
    icon-theme-package
    adwaita-qt
    nautilus
    adwaita-icon-theme
    git
    firefox
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
    swaybg
    wl-clipboard
    wiremix
    wireplumber
    pulseaudio
    imagemagick
    slurp
    grim
    wlsunset
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    udiskie
    keepassxc
    imv
    mpv
    zathura
    yazi
  ];

  home-manager.users.shaonix = {
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;

    systemd.user.sessionVariables = {
      GDK_BACKEND                        = "wayland,x11";
    };

    gtk = {
      enable    = true;
      iconTheme = {
        name    = "Gruvbox-Plus-Light";
        package = pkgs.gruvbox-plus-icons;
      };
    };

    qt = {
      enable             = true;
      platformTheme.name = lib.mkForce "gtk";
      style.name         = lib.mkForce "adwaita";
    };

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
          match app-id="org.gnome.Nautilus"
          open-floating true
      }
      window-rule {
          match app-id="xdg-desktop-portal-gtk"
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
          match app-id="imv"
          open-floating true
      }

      spawn-at-startup "udiskie" "-t"
      spawn-at-startup "swaybg" "-i" "/etc/nixos/wallpaper.jpg" "-m" "fill"
      spawn-at-startup "wlsunset" "-t" "4500" "-T" "4500"
      spawn-at-startup "xwayland-satellite"

      binds {
          Mod+Return { spawn "alacritty"; }
          Mod+Space  { spawn "fuzzel"; }
          Mod+B      { spawn "firefox"; }
          Mod+C         { close-window; }
          Mod+F         { maximize-column; }
          Mod+Shift+Space { toggle-window-floating; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-or-workspace-down; }
          Mod+K     { focus-window-or-workspace-up; }
          Mod+L     { focus-column-right; }
          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-or-workspace-down; }
          Mod+Up    { focus-window-or-workspace-up; }
          Mod+Right { focus-column-right; }
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
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          XF86AudioMute        { spawn "sh" "-c" "pactl set-sink-mute @DEFAULT_SINK@ toggle"; }
          XF86AudioLowerVolume { spawn "sh" "-c" "pactl set-sink-volume @DEFAULT_SINK@ -2%"; }
          XF86AudioRaiseVolume { spawn "sh" "-c" "pactl set-sink-volume @DEFAULT_SINK@ +2%"; }
          Mod+Shift+X { spawn "hyprlock"; }
          Mod+Shift+E { quit; }
      }
    '';

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

    programs.bash = {
      enable    = true;
      initExtra = ''
        set -o vi
        PS1='\[\e[38;2;224;137;161m\]\w \[\e[0m\]❯ '
      '';
      shellAliases = {
        ls  = "eza -l -a -h";
        ll  = "eza -l -a -h";
        vim = "hx";
      };
    };

    programs.eza = {
      enable                = true;
      enableBashIntegration = true;
    };

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

    home.file.".config/yazi/yazi.toml".text = ''
      [mgr]
      show_hidden = true

      [opener]
      edit     = [{ run = 'alacritty -e hx "$@"', orphan = true }]
      image    = [{ run = 'imv "$@"', orphan = true, for = "unix" }]
      video    = [{ run = 'mpv "$@"', orphan = true, for = "unix" }]
      audio    = [{ run = 'mpv --force-window --no-resume-playback "$@"', orphan = true }]
      pdf      = [{ run = 'zathura "$@"', orphan = true, for = "unix" }]
      browser  = [{ run = 'firefox "$@"', orphan = true, for = "unix" }]

      [open]
      rules = [
        { mime = "image/*",         use = "image" },
        { mime = "video/*",         use = "video" },
        { mime = "audio/*",         use = "audio" },
        { mime = "text/*",          use = "edit" },
        { mime = "application/pdf", use = "pdf" },
        { mime = "text/html",       use = "browser" },
        { mime = "application/xhtml+xml", use = "browser" },
      ]
    '';

    home.file.".config/yazi/theme.toml".text = ''
      [mgr]
      cwd             = { fg = "#458588", bold = true }
      hovered         = { fg = "#FDF6E3", bg = "#458588" }
      find_keyword    = { fg = "#458588", bold = true }
      find_position   = { fg = "#C67F3A", bg = "reset", bold = true }
      marker_copied   = { fg = "#458588", bg = "#458588" }
      marker_cut      = { fg = "#CC3333", bg = "#CC3333" }
      marker_selected = { fg = "#458588", bg = "#458588" }
      count_copied    = { fg = "#FDF6E3", bg = "#458588" }
      count_cut       = { fg = "#FDF6E3", bg = "#CC3333" }
      count_selected  = { fg = "#FDF6E3", bg = "#458588" }

      [tabs]
      active   = { fg = "#FDF6E3", bg = "#458588", bold = true }
      inactive = { fg = "#8B7355", bg = "#D9D3C3" }

      [status]
      mode_normal = { fg = "#FDF6E3", bg = "#458588", bold = true }
      mode_select = { fg = "#FDF6E3", bg = "#458588", bold = true }
      mode_unset  = { fg = "#FDF6E3", bg = "#458588", bold = true }

      [filetype]
      rules = [
        { mime = "image/*",         fg = "#458588" },
        { mime = "video/*",         fg = "#C67F3A" },
        { mime = "audio/*",         fg = "#458588" },
        { mime = "text/*",          fg = "#000000" },
        { mime = "inode/directory", fg = "#C67F3A", bold = true },
        { mime = "*.nix",           fg = "#458588" },
        { mime = "*.sh",            fg = "#458588" },
        { mime = "*.md",            fg = "#000000" },
        { mime = "*.toml",          fg = "#C67F3A" },
        { mime = "*.json",          fg = "#9A7D0A" },
      ]
    '';
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree          = true;
  system.stateVersion = "26.05";
}
