{ config, pkgs, lib, theme, themeNoHash, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      truecolor        = true;
      force_tty        = false;
      shown_boxes      = "cpu net proc";
      update_ms        = 2000;
      presets          = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys         = true;
      rounded_corners  = true;
      graph_symbol     = "braille";
      proc_sorting     = "cpu lazy";
      proc_colors      = true;
      proc_gradient    = true;
      proc_mem_bytes   = true;
      proc_cpu_graphs  = true;
      base_10_sizes    = true;
    };
  };

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
      background_opacity      = "1.0";
      cursor_shape            = "block";
      font_family             = "JetBrainsMono Nerd Font";
      font_size               = 16;
      cursor_trail            = 3;
      background              = theme.base00;
      foreground              = theme.base07;
      cursor                  = theme.base07;
      cursor_text_color       = theme.base00;
      selection_background    = theme.base02;
      selection_foreground    = theme.base05;
      active_tab_background   = theme.base00;
      active_tab_foreground   = theme.base06;
      inactive_tab_background = theme.base01;
      inactive_tab_foreground = theme.base03;
      color0  = theme.base00; color8  = theme.base02;
      color1  = theme.base08; color9  = theme.base08;
      color2  = theme.base0B; color10 = theme.base0B;
      color3  = theme.base0A; color11 = theme.base0A;
      color4  = theme.base0D; color12 = theme.base0D;
      color5  = theme.base0E; color13 = theme.base0E;
      color6  = theme.base0C; color14 = theme.base0C;
      color7  = theme.base03; color15 = theme.base03;
      enable_audio_bell   = "no";
      allow_remote_control = "yes";
      shell_integration   = "enabled";
    };
  };

  services.mako = {
    enable = true;
    settings = {
      border-size       = 2;
      border-radius     = 6;
      font              = lib.mkForce "JetBrainsMono Nerd Font 13";
      width             = 400;
      height            = 120;
      padding           = "12";
      margin            = "10";
      default-timeout   = 11000;
      ignore-timeout    = 0;
      background-color  = lib.mkForce theme.base01;
      text-color        = lib.mkForce theme.base06;
      border-color      = lib.mkForce theme.base0D;
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
      colors = {
        background      = "${themeNoHash.base00}ff";
        text            = "${themeNoHash.base06}ff";
        match           = "${themeNoHash.base0B}ff";
        selection       = "${themeNoHash.base01}ff";
        selection-text  = "${themeNoHash.base06}ff";
        selection-match = "${themeNoHash.base0A}ff";
        border          = "${themeNoHash.base0D}ff";
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

  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "kitty-direct",
        "source": "/home/az/dirrr/nix-gruvbox.png",
        "width": 32,
        "height": 15,
        "padding": { "top": 1, "left": 1, "right": 4 }
      },
      "display": { "separator": " : " },
      "modules": [
        "break",
        { "type": "custom", "format": "\u001b[90m┌──────────────────────Hardware──────────────────────┐" },
        { "type": "host",    "key": " PC",  "keyColor": "green" },
        { "type": "cpu",     "key": "│ ├",  "showPeCoreCount": true, "keyColor": "green" },
        { "type": "gpu",     "key": "│ ├",  "detectionMethod": "pci", "keyColor": "green" },
        { "type": "display", "key": "│ ├󱄄", "keyColor": "green" },
        { "type": "disk",    "key": "│ ├󰋊", "keyColor": "green" },
        { "type": "memory",  "key": "│ ├",  "keyColor": "green" },
        { "type": "swap",    "key": "└ └󰓡 ", "keyColor": "green" },
        { "type": "custom", "format": "\u001b[90m└────────────────────────────────────────────────────┘" },
        "break",
        { "type": "custom", "format": "\u001b[90m┌──────────────────────Software──────────────────────┐" },
        { "type": "command", "key": "\ue900 OS",  "keyColor": "blue", "text": "version=$(nixos-version); echo \"nixos $version\"" },
        { "type": "command", "key": "│ ├󰘬",       "keyColor": "blue", "text": "branch=$(nixos-version-branch); echo \"$branch\"" },
        { "type": "command", "key": "│ ├󰔫",       "keyColor": "blue", "text": "channel=$(nixos-version-channel); echo \"$channel\"" },
        { "type": "kernel",  "key": "│ ├",        "keyColor": "blue" },
        { "type": "wm",      "key": "│ ├",        "keyColor": "blue" },
        { "type": "de",      "key": " DE",        "keyColor": "blue" },
        { "type": "terminal","key": "│ ├",        "keyColor": "blue" },
        { "type": "packages","key": "│ ├󰏖",       "keyColor": "blue" },
        { "type": "wmtheme", "key": "│ ├󰉼",       "keyColor": "blue" },
        { "type": "command", "key": "│ ├󰸌",       "keyColor": "blue", "text": "theme=$(nixos-theme-current); echo -e \"$theme \\e[38m●\\e[37m●\\e[36m●\\e[35m●\\e[34m●\\e[33m●\\e[32m●\\e[31m●\"" },
        { "type": "terminalfont", "key": "└ └",   "keyColor": "blue" },
        { "type": "custom", "format": "\u001b[90m└────────────────────────────────────────────────────┘" },
        "break",
        { "type": "custom", "format": "\u001b[90m┌────────────────Age / Uptime / Update───────────────┐" },
        { "type": "command", "key": "󱦟 OS Age", "keyColor": "magenta", "text": "echo $(( ($(date +%s) - $(stat -c %W /)) / 86400 )) days" },
        { "type": "uptime",  "key": "󱫐 Uptime", "keyColor": "magenta" },
        { "type": "command", "key": " Update",  "keyColor": "magenta", "text": "updated=$(nixos-version-pkgs); echo \"$updated\"" },
        { "type": "custom", "format": "\u001b[90m└────────────────────────────────────────────────────┘" },
        "break"
      ]
    }
  '';


  home.file.".config/yazi/yazi.toml".text = ''
    [mgr]
    show_hidden = true
    [opener]
    edit = [
        { run = 'nvim "$@"', block = true, for = "unix" },
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
        { run = 'evince "$@"', orphan = true, desc = "Open PDF", for = "unix" },
    ]
    [[opener.browser]]
    run = 'firefox "$@"'
    orphan = true
    desc = "Open in Firefox"
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
      { name = "*.nix",           fg = "${theme.base0D}" },
      { name = "*.rs",            fg = "${theme.base09}" },
      { name = "*.py",            fg = "${theme.base0A}" },
      { name = "*.sh",            fg = "${theme.base0B}" },
      { name = "*.md",            fg = "${theme.base06}" },
      { name = "*.toml",          fg = "${theme.base09}" },
      { name = "*.json",          fg = "${theme.base0A}" },
    ]
  '';

  home.file.".config/nvim/lua/plugins/colorscheme.lua".text = ''
    return {
      {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {
          contrast = "hard",
          overrides = {
            Normal         = { bg = "${theme.base00}" },
            NormalNC       = { bg = "${theme.base00}" },
            SignColumn     = { bg = "${theme.base00}" },
            EndOfBuffer    = { bg = "${theme.base00}" },
            NormalFloat    = { bg = "${theme.base00}" },
            Boolean        = { fg = "${theme.base0E}", bg = "NONE" },
            Number         = { fg = "${theme.base0E}", bg = "NONE" },
            Float          = { fg = "${theme.base0E}", bg = "NONE" },
            String         = { fg = "${theme.base0B}", bg = "NONE", italic = true },
            Function       = { fg = "${theme.base0B}", bold = true, italic = true },
            Keyword        = { fg = "${theme.base08}" },
            Type           = { fg = "${theme.base0A}" },
            Operator       = { fg = "${theme.base09}" },
            Comment        = { fg = "${theme.base03}", italic = true },
            ["@string"]    = { fg = "${theme.base0B}", italic = true },
            ["@number"]    = { fg = "${theme.base0E}" },
            ["@boolean"]   = { fg = "${theme.base0E}" },
            ["@function"]  = { fg = "${theme.base0B}", bold = true, italic = true },
            ["@keyword"]   = { fg = "${theme.base08}" },
            ["@type"]      = { fg = "${theme.base0C}", bold = true },
            ["@variable"]  = { fg = "${theme.base0D}" },
            ["@field"]     = { fg = "${theme.base09}" },
            ["@property"]  = { fg = "${theme.base09}" },
            ["@attribute"] = { fg = "${theme.base09}" },
            ["@punctuation"] = { fg = "${theme.base09}" },
          },
        },
      },
      {
        "LazyVim/LazyVim",
        opts = { colorscheme = "gruvbox" },
      },
    }
  '';

  home.file.".config/nvim/lua/plugins/lsp.lua".text = ''
    return {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "pyright", "ruff-lsp", "html-lsp", "css-lsp",
            "typescript-language-server", "prettier", "eslint-lsp",
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            pyright  = {},
            ruff_lsp = {},
            html     = {},
            cssls    = {},
            tsserver = {},
          },
        },
      },
    }
  '';

  home.file.".config/.emoji".text = ''
    🔥 fire hot
    💯 hundred perfect
    ✨ sparkles magic
    💙 blue heart
    🤍 white heart
    ⚡ lightning fast energy
    🌙 moon night
    ☀️ sun bright day
    🍁 maple leaf autumn
    🦀 crab animal
    🦞 lobster seafood
    🦐 shrimp seafood
    ❄️ snowflake winter
    📚 books study
    ✏️ pencil write
    🧬 dna genetics
    ⚛️ atom science
    🍫 chocolate
    🍕 pizza
    🌺 hibiscus flower
    🦉 owl bird
    🐧 penguin
    🐼 panda
    🤝 handshake
    🌸 cherry blossom
  '';
}
