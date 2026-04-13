{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # IDEs / Text editors
    neovim
    positron-bin

    # Languages
    R
    rPackages.ggplot2
    rPackages.tidyverse
    rPackages.gtable   # Fixed: Added the prefix
    rPackages.dplyr    # Fixed: Added the prefix

    # Writings
    typst

    # Terminal emulators
    kitty
    
    # Visuals
    pipes

    # Browsers
    google-chrome
    tor-browser

    # Image viewer
    imv

    # Media player
    mpv

    # Image / Video editors
    gimp
    inkscape

    # Topbar
    waybar

    # Application launcher
    fuzzel

    # Audio
    wiremix
    wireplumber
    pamixer
    
    # Clipboard
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
    wtype

    # File managers / drive mounting
    yazi
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.tumbler
    gvfs
    udisks2
    udiskie
    gnome-disk-utility
    unzip
    p7zip

    # Password manager
    keepassxc

    # Notifications
    mako
    libnotify

    # Screenshots
    slurp
    grim
    
    # Screen recorders
    obs-studio
    gpu-screen-recorder

    # Night light
    hyprsunset

    # Task manager
    btop

    # System info
    fastfetch

    # Display
    ddcutil
    wlr-randr
    hypridle
    swaybg
    xdg-desktop-portal-gtk
    polkit_gnome
    qt5.qtwayland
    brightnessctl
    swww

    # Manual pages
    man-db

    # Calculator
    gnome-calculator

    # Network
    iwd
    networkmanagerapplet
    
    # Utils
    wget
    nh
    lolcat
    bat
    figlet
    starship
    atuin
    zoxide
    ncdu
    dust
    fd
    ripgrep
    fzf
    eza
    tree
    jq
    yq
    less
    playerctl
    plocate
    curl
    tldr
    clang
    python3
    luarocks
    imagemagick
    yt-dlp
    evince
    gnome-keyring
    libqalculate
    fcitx5
    fcitx5-gtk
    snapper
    gum
    hyprpicker
    tree-sitter
    wev
    git
  ];

  services.gvfs.enable               = true;
  services.udisks2.enable             = true;
  services.avahi.enable               = true;
  services.avahi.nssmdns4             = true;
  services.power-profiles-daemon.enable = true;
  programs.fish.enable = true;

  hardware.bluetooth.enable = true;
  zramSwap.enable           = true;
}
