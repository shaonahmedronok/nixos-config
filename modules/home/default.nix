{ config, pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./programs.nix
    ./scripts.nix
  ];

  home.username    = "az";
  home.homeDirectory = "/home/az";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  stylix.targets.qt.enable       = false;
  stylix.targets.kitty.enable    = false;
  stylix.targets.waybar.enable   = false;
  stylix.targets.neovim.enable   = false;
  stylix.targets.hyprland.enable = false;
  stylix.targets.starship.enable = false;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.mpv.enable      = false;
  stylix.targets.fuzzel.enable   = false;

  programs.bash = {
    enable    = true;
    initExtra = "";
    shellAliases = {
      ls  = "eza --icons";
      ll  = "eza -la --icons";
      cat = "bat";
      cd  = "z";
      vim = "nvim";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
      zoxide init fish | source
      set fish_color_command green
      set fish_color_param normal
      set fish_color_error brred
      set fish_color_quote yellow
      set fish_color_redirection cyan
      set fish_color_end green
      set fish_color_comment brblack
      set fish_color_operator blue
      set fish_color_autosuggestion brblack
      set fish_color_valid_path --underline
    '';
    shellAliases = {
      ls  = "eza --icons";
      ll  = "eza -la --icons";
      cat = "bat";
      vim = "nvim";
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
        style             = "bold #ebdbb2";
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
      user.name      = "shaonahmedronok1";
      user.email     = "shaonbtw@gmail.com";
      safe.directory = "/etc/nixos";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"                  = "thunar.desktop";
      "application/x-gnome-saved-search" = "thunar.desktop";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name    = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable             = true;
    platformTheme.name = lib.mkForce "gtk";
    style.name         = lib.mkForce "adwaita-dark";
  };
}
