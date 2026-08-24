{ config, pkgs, lib, theme, themeNoHash, ... }:
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
      sub-font              = "JetBrainsMono Nerd Font Mono";
      sub-font-size         = 33;
      sub-border-size       = 3;
      sub-shadow-offset     = 1;
      sub-pos               = 98;
      sub-align-y           = "bottom";
      sub-margin-y          = 20;
      osd-font              = "JetBrainsMono Nerd Font";
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

  

  programs.kitty = {
    enable = true;
    settings = {
    window_padding_width    = 10;
    cursor_shape            = "block";
    font_family             = "JetBrainsMono Nerd Font";
    font_size               = 16;
    bold_font_family        = "JetBrainsMono Nerd Font Bold";
    italic_font_family      = "JetBrainsMono Nerd Font Italic";
    bold_italic_font_family = "JetBrainsMono Nerd Font Bold Italic";
    cursor_trail            = 3;
      enable_audio_bell   = "no";
      allow_remote_control = "yes";
      shell_integration   = "enabled";
    };
  };


  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font     = lib.mkForce "JetBrainsMono Nerd Font:size=16";
        lines    = 12;
        width    = 45;
        terminal = "kitty";
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
        background               = themeNoHash.base00;
        overlay_text_color       = themeNoHash.base06;
        overlay_background_color = themeNoHash.base01;
        overlay_font             = "JetBrainsMono Nerd Font:12";
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
        { run = 'kitty -e hx "$@"', orphan = true },
    ]
    open = [
        { run = 'xdg-open "$@"', desc = "Open", for = "unix" },
    ]
    image = [
        { run = 'imv "$@"', orphan = true, for = "unix" },
    ]
    play_audio = [
        { run = 'killall -q mpv; mpv --force-window --no-resume-playback "$@"', desc = "Play Audio" }
    ]
    
    open_pdf = [
    { run = 'zathura "$@"', orphan = true, desc = "Open PDF", for = "unix" },
]

    [[opener.browser]]
    run = 'helium "$@"'
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
    cwd             = { fg = "${theme.base0B}", bold = true }
    hovered         = { fg = "${theme.base00}", bg = "${theme.base0B}" }
    find_keyword    = { fg = "${theme.base0B}", bold = true }
    find_position   = { fg = "${theme.base09}", bg = "reset", bold = true }
    marker_copied   = { fg = "${theme.base0B}", bg = "${theme.base0B}" }
    marker_cut      = { fg = "${theme.base08}", bg = "${theme.base08}" }
    marker_selected = { fg = "${theme.base0D}", bg = "${theme.base0D}" }
    count_copied    = { fg = "${theme.base00}", bg = "${theme.base0B}" }
    count_cut       = { fg = "${theme.base00}", bg = "${theme.base08}" }
    count_selected  = { fg = "${theme.base00}", bg = "${theme.base0D}" }
    border_symbol   = "│"
    border_style    = { fg = "${theme.base03}" }

    [indicator]
    preview = { underline = true }

    [tabs]
    active   = { fg = "${theme.base00}", bg = "${theme.base0B}", bold = true }
    inactive = { fg = "${theme.base04}", bg = "${theme.base01}" }

    [status]
    separator_open  = ""
    separator_close = ""
    separator_style = { fg = "${theme.base01}", bg = "${theme.base01}" }
    mode_normal     = { fg = "${theme.base00}", bg = "${theme.base0B}", bold = true }
    mode_select     = { fg = "${theme.base00}", bg = "${theme.base0B}", bold = true }
    mode_unset      = { fg = "${theme.base00}", bg = "${theme.base0D}", bold = true }
    progress_label  = { fg = "${theme.base06}", bold = true }
    progress_normal = { fg = "${theme.base0D}", bg = "${theme.base01}" }
    progress_error  = { fg = "${theme.base08}", bg = "${theme.base01}" }
    permissions_t   = { fg = "${theme.base09}" }
    permissions_r   = { fg = "${theme.base0B}" }
    permissions_w   = { fg = "${theme.base08}" }
    permissions_x   = { fg = "${theme.base0D}" }
    permissions_s   = { fg = "${theme.base03}" }

    [input]
    border   = { fg = "${theme.base09}" }
    title    = {}
    value    = {}
    selected = { reversed = true }

    [select]
    border   = { fg = "${theme.base09}" }
    active   = { fg = "${theme.base0B}", bold = true }
    inactive = {}

    [tasks]
    border  = { fg = "${theme.base09}" }
    title   = {}
    hovered = { underline = true }

    [which]
    cols            = 3
    mask            = { bg = "${theme.base01}" }
    cand            = { fg = "${theme.base0B}" }
    rest            = { fg = "${theme.base03}" }
    desc            = { fg = "${theme.base06}" }
    separator       = "  "
    separator_style = { fg = "${theme.base03}" }

    [notify]
    title_info  = { fg = "${theme.base0B}" }
    title_warn  = { fg = "${theme.base0A}" }
    title_error = { fg = "${theme.base08}" }

    [filetype]
    rules = [
      { mime = "image/*",         fg = "${theme.base0D}" },
      { mime = "video/*",         fg = "${theme.base09}" },
      { mime = "audio/*",         fg = "${theme.base0B}" },
      { mime = "text/*",          fg = "${theme.base06}" },
      { mime = "inode/directory", fg = "${theme.base09}", bold = true },
      { mime = "*.nix",           fg = "${theme.base0D}" },
      { mime = "*.rs",            fg = "${theme.base09}" },
      { mime = "*.py",            fg = "${theme.base0A}" },
      { mime = "*.sh",            fg = "${theme.base0B}" },
      { mime = "*.md",            fg = "${theme.base06}" },
      { mime = "*.toml",          fg = "${theme.base09}" },
      { mime = "*.json",          fg = "${theme.base0A}" },
    ]
  '';
}
