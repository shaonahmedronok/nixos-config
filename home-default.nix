{ config, pkgs, lib, ... }:
{
  imports = [
    ./home-wm.nix
    ./programs.nix
    ./scripts.nix
  ];

  home.username      = "shaonix";
  home.homeDirectory = "/home/shaonix";
  home.stateVersion  = "26.05";
  programs.home-manager.enable = true;

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
      ls  = "eza -l -a -a -h ";
      ll  = "eza -l -a -a -h ";
      vim = "hx";
    };
  };

  programs.eza = {
    enable                = true;
    enableBashIntegration = true;
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
      "inode/directory"                  = [ "org.gnome.Nautilus.desktop" ];
      "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
      "text/plain"                       = [ "helix.desktop" ];
      "text/x-nix"                       = [ "helix.desktop" ];
      "text/markdown"                    = [ "helix.desktop" ];
      "application/json"                 = [ "helix.desktop" ];
      "text/x-shellscript"               = [ "helix.desktop" ];
      "text/x-org"                       = [ "helix.desktop" ];
      "application/pdf"                  = [ "zathura.desktop" ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name    = "Gruvbox-Plus-light";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 0;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 0;
  };

  qt = {
    enable             = true;
    platformTheme.name = lib.mkForce "gtk";
    style.name         = lib.mkForce "adwaita";
  };
}
