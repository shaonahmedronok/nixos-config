{ config, pkgs, lib, ... }:
{
  imports = [
    ./home-niri.nix
    # noctalia.nix removed — ditched
    ./programs.nix
    ./scripts.nix
  ];

  home.username      = "az";
  home.homeDirectory = "/home/az";
  home.stateVersion  = "26.05";
  programs.home-manager.enable = true;

  stylix.targets.gtk.enable      = false;
  stylix.targets.niri.enable     = false;
  stylix.targets.qt.enable       = false;
  stylix.targets.kitty.enable    = true;
  stylix.targets.helix.enable    = true;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.mpv.enable      = false;
  stylix.targets.gnome.enable    = false;
  stylix.targets.fuzzel.enable   = true;

  programs.bash = {
    enable    = true;
    initExtra = "";
    shellAliases = {
      ls = "eza -l -a -a -h --icons";
      ll = "eza -l -a -a -h --icons";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
      bind -M insert ctrl-backspace backward-kill-word
      bind -M insert alt-backspace backward-kill-word

      function fish_mode_prompt
      end

      function fish_prompt
        set -l last_status $status

        set_color --bold 458588
        echo -n " "
        set_color normal

        if test -n "$IN_NIX_SHELL"
          set_color --bold 2E8B84
          echo -n "❄ "
          set_color normal
        end

        set_color --bold 458588
        echo -n (prompt_pwd --full-length-dirs 1 --dir-length 3)
        set_color normal

        if git rev-parse --git-dir >/dev/null 2>&1
          set_color e089a1
          echo -n "  "(git branch --show-current)
          set_color normal
        end

        echo ""

        if test $last_status -eq 0
          set_color --bold b8bb26
        else
          set_color --bold CC3333
        end
        echo -n "❯ "
        set_color normal
      end

      function fish_right_prompt
      end
    '';
    shellAliases = {
      ls  = "eza -l -a -a -h --icons";
      ll  = "eza -l -a -a -h --icons";
      vim = "hx";
    };
  };

  programs.eza = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  xdg.desktopEntries.helix = {
    name        = "Helix";
    genericName = "Text Editor";
    exec        = "kitty -e hx %F";
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
