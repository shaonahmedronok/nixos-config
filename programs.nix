{ config, pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      profile               = "fast";
      vo                    = "gpu";
      hwdec                 = "vaapi";
      "gpu-api"             = "opengl";
      save-position-on-quit = true;
      osc                   = false;
      border                = false;
      cursor-autohide       = 1000;
      slang                 = "en,eng,enUS,enGB,enAU,enNZ,enCA,enIE,enZA";
      ytdl-raw-options      = "ignore-config=,sub-langs=\"en.*,^en\",write-subs=,write-auto-subs=";
      sub-visibility        = "yes";
      sub-auto              = "fuzzy";
      sub-font              = "Iosevka";
      sub-font-size         = 33;
      sub-border-size       = 3;
      sub-shadow-offset     = 1;
      sub-pos               = 98;
      sub-align-y           = "bottom";
      sub-margin-y          = 20;
      osd-font              = "Iosevka";
      osd-font-size         = 28;
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

programs.alacritty = {
  enable = true;
  settings = {
    font = {
      size = 18;
      normal = {
        family = "Iosevka";
        style = "Regular";
      };
      bold = {
        family = "Iosevka";
        style = "Bold";
      };
      italic = {
        family = "Iosevka";
        style = "Italic";
      };
      bold_italic = {
        family = "Iosevka";
        style = "Bold Italic";
      };
    };

    window.padding = {
      x = 10;
      y = 10;
    };

    cursor.style.shape = "Block";

    colors = {
      primary = {
        background = "#FDF6E3";
        foreground = "#000000";
      };
      selection = {
        text = "#000000";
        background = "#D9D3C3";
      };
      cursor = {
        cursor = "#458588";
      };
      normal = {
        black   = "#FDF6E3"; # color0
        red     = "#CC3333"; # color1
        green   = "#458588"; # color2
        yellow  = "#9A7D0A"; # color3
        blue    = "#458588"; # color4
        magenta = "#e089a1"; # color5
        cyan    = "#2E8B84"; # color6
        white   = "#000000"; # color7
      };
      bright = {
        black   = "#999999"; # color8
        red     = "#CC3333"; # color9
        green   = "#458588"; # color10
        yellow  = "#9A7D0A"; # color11
        blue    = "#458588"; # color12
        magenta = "#e089a1"; # color13
        cyan    = "#2E8B84"; # color14
        white   = "#000000"; # color15
      };
    };
  };
};

  programs.fuzzel = {
    enable = true;
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

programs.imv = {
  enable = true;
  settings = {
    options = {
      background               = "FDF6E3";
      overlay_text_color       = "000000";
      overlay_background_color = "D9D3C3";
      overlay_font             = "Iosevka:15";
    };

      binds = {
        "<Ctrl+p>"       = ''exec lp "$imv_current_file"'';
        "<Ctrl+x>"       = ''exec rm "$imv_current_file"; quit'';
        "<Ctrl+Shift+X>" = ''exec rm "$imv_current_file"; close'';
        "<Ctrl+r>"       = ''exec mogrify -rotate 90 "$imv_current_file"'';
      };
    };
  };


programs.helix = {
  enable = true;
  defaultEditor = true;

  settings = {
    theme = "solarized_light";
    editor = {
      line-number = "relative";
      mouse = true;
      clipboard-provider = "wayland";
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      lsp = {
        display-messages = true;
        display-inlay-hints = true;
      };
      statusline = {
        left = [ "mode" "spinner" ];
        center = [ "file-name" "file-modification-indicator" ];
        right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
        mode = {
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
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = { command = "${pkgs.nixfmt}/bin/nixfmt"; };
        language-servers = [ "nixd" ];
      }
    ];
    language-server = {
      nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
    };
  };
};


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
        { mime = "audio/*",         use = "play_audio" },
        { mime = "image/*",         use = "image" },
        { mime = "text/*",          use = "edit" },
        { mime = "video/*",         use = [ "open" ] },
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
    cols            = 3
    mask            = { bg = "#D9D3C3" }
    cand            = { fg = "#458588" }
    rest            = { fg = "#999999" }
    desc            = { fg = "#000000" }
    separator       = "  "
    separator_style = { fg = "#999999" }

    [notify]
    title_info  = { fg = "#458588" }
    title_warn  = { fg = "#9A7D0A" }
    title_error = { fg = "#CC3333" }

    [filetype]
    rules = [
      { mime = "image/*",         fg = "#458588" },
      { mime = "video/*",         fg = "#C67F3A" },
      { mime = "audio/*",         fg = "#458588" },
      { mime = "text/*",          fg = "#000000" },
      { mime = "inode/directory", fg = "#C67F3A", bold = true },
      { mime = "*.nix",           fg = "#458588" },
      { mime = "*.rs",            fg = "#C67F3A" },
      { mime = "*.py",            fg = "#9A7D0A" },
      { mime = "*.sh",            fg = "#458588" },
      { mime = "*.md",            fg = "#000000" },
      { mime = "*.toml",          fg = "#C67F3A" },
      { mime = "*.json",          fg = "#9A7D0A" },
    ]
  '';
}
