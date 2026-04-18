{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # IDEs / Text editors
    neovim

    # Writings
    typst

    # Terminal emulators
    kitty
    
    # Browsers
    google-chrome
    tor-browser

    # Image viewer
    imv

    # Media player
    mpv

    # Image / Video editors
    inkscape

    # Topbar
    waybar

    # Application launcher
    fuzzel

    # Audio
    wiremix
    wireplumber
    pamixer
    sonic-pi

    # Clipboard
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
    wtype

    # File managers / drive mounting
    yazi
    udiskie
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
    ffmpeg
    wf-recorder

    # Night light
    wlsunset

    # Task manager
    btop

    # System info
    fastfetch

    # Display
    ddcutil
    wlr-randr
    hypridle
    xdg-desktop-portal-gtk
    polkit_gnome
    qt5.qtwayland
    brightnessctl
    swww
    xwayland-satellite

    # Manual pages
    man-db

    # Network
    iwd
    networkmanagerapplet
    
    # Utils
    nh
    bat
    starship
    atuin
    zoxide
    fd
    ripgrep
    fzf
    eza
    jq
    playerctl
    curl
    clang
    python3
    luarocks
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

  services.udisks2.enable             = true;
  services.avahi.enable               = true;
  services.avahi.nssmdns4             = true;
  services.power-profiles-daemon.enable = true;
  programs.fish.enable = true;

  zramSwap.enable           = true;
}
