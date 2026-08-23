{ config, pkgs, lib, themeNoHash, inputs, ... }:
{
  imports = [
  ./nix.nix
  ./pipewire.nix
  ./gtk.nix
  ./nixos-niri.nix
  ./general.nix
  ./academia.nix
  inputs.helium.nixosModules.default
];

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "i2c-dev" ];

  networking.hostName              = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable       = true;

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




  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  users.users.az = {
    isNormalUser = true;
    description  = "az";
    extraGroups  = [ "networkmanager" "wheel" "video" "input" "storage" "i2c" ];
    packages     = [];
    shell        = pkgs.fish;
  };

  security.pam.services.hyprlock = {};

  hardware.graphics.enable           = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable                = true;

  security.polkit.enable = true;

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      user    = "az";
      command = "niri-session";
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];


fonts.fontconfig = {
  defaultFonts = {
    sansSerif = [ "Noto Sans" "Noto Sans Bengali" ];
    serif     = [ "Noto Serif" "Noto Serif Bengali" ];
  };
};



i18n.inputMethod = {
  type = "fcitx5";
  enable = true;
  fcitx5.waylandFrontend = true;
  fcitx5.addons = with pkgs; [
    fcitx5-openbangla-keyboard
    fcitx5-gtk
  ];
};


programs.helium = {
  enable = true;
  flags = [
    "--ozone-platform-hint=auto"
    "--enable-wayland-ime"
  ];
};

  stylix = {
    enable   = true;
    polarity = "light";
    
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
    image = ./wallpaper.jpg;
    fonts.monospace = {
      name    = "JetBrainsMono Nerd Font Mono";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    fonts.emoji = {
      name    = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
  };

  

  swapDevices = [
  {
    device   = "/var/lib/swapfile";
    size     = 8 * 1024;  # 8 GiB, in MiB — official syntax confirmed at wiki.nixos.org/wiki/Swap
    priority = 0;         # lower than zram's default priority (5), used only as overflow
  }
];



  # Written to /etc/environment — PAM propagates this to the systemd user
  # session, so every app niri-session launches (KeepassXC, Chrome, Thunar)
  # receives these variables.
  environment.sessionVariables = {
    NIXOS_OZONE_WL                    = "1";
    XDG_CURRENT_DESKTOP               = "niri:GNOME";
    XDG_SESSION_TYPE                  = "wayland";
    XDG_SESSION_DESKTOP               = "niri";
    QT_QPA_PLATFORM                   = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.variables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";
  };

  system.stateVersion = "26.05";
}
