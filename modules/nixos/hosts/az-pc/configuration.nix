{ config, pkgs, lib, themeNoHash, ... }:
{
  imports = [
    ../../features/nix.nix
    ../../features/pipewire.nix
    ../../features/gtk.nix
    ../../features/hyprland.nix
    ../../features/general.nix
    ../../features/r-studio.nix
  ];

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules                   = [ "i2c-dev" ];

  networking.hostName              = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable       = true;

  time.timeZone      = "America/Los_Angeles";
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

  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  users.users.az = {
    isNormalUser = true;
    description  = "az";
    extraGroups  = [ "networkmanager" "wheel" "video" "input" "storage" "i2c" ];
    packages     = [];
  };

  security.pam.services.hyprlock = {};

  hardware.graphics.enable           = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable                = true;

  security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      user    = "az";
      command = "Hyprland";
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    atkinson-hyperlegible
    font-awesome
  ];

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = themeNoHash.base00;
      base01 = themeNoHash.base01;
      base02 = themeNoHash.base02;
      base03 = themeNoHash.base03;
      base04 = themeNoHash.base04;
      base05 = themeNoHash.base05;
      base06 = themeNoHash.base06;
      base07 = themeNoHash.base07;
      base08 = themeNoHash.base08;
      base09 = themeNoHash.base09;
      base0A = themeNoHash.base0A;
      base0B = themeNoHash.base0B;
      base0C = themeNoHash.base0C;
      base0D = themeNoHash.base0D;
      base0E = themeNoHash.base0E;
      base0F = themeNoHash.base0F;
    };
    image = ../../../../wallpaper.jpg;
    fonts.monospace = {
      name    = "JetBrainsMono Nerd Font Mono";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    fonts.sansSerif = {
      name    = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    fonts.serif = {
      name    = "Noto Serif";
      package = pkgs.noto-fonts;
    };
    fonts.emoji = {
      name    = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
  };

  environment.variables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";
  };

  system.stateVersion = "25.11";
}
