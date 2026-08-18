{ config, pkgs, lib, ... }:
{
  imports = [
    ./home-niri.nix
    ./noctalia.nix
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
  stylix.targets.starship.enable = true;
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
      zoxide init fish | source
      bind -M insert ctrl-backspace backward-kill-word
      bind -M insert alt-backspace backward-kill-word
    '';
    shellAliases = {
      ls  = "eza -l -a -a -h --icons";
      ll  = "eza -l -a -a -h --icons";
      cat = "bat";
      vim = "hx";
    };
  };



  programs.starship = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[❯](bold #b8bb26)";
        error_symbol   = "[❯](bold #fb4934)";
      };
      nix_shell.symbol  = " ";
      git_branch.symbol = " ";
      directory = {
        truncation_length = 3;
        style             = "bold #458588";
      };
    };
  };




  programs.zoxide = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;

  programs.atuin = {
    enable                = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      filter_mode_shell_up_arrow_history = "global";
    };
  };

  programs.git = {
    enable   = true;
    settings = {
      user.name      = "shaonahmedronok";
      user.email     = "shaonbtw@gmail.com";
      safe.directory = "/etc/nixos";
    };
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
