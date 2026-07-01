{ pkgs, ... }:
{

environment.sessionVariables = {
  NIXOS_OZONE_WL        = "1";
};


  environment.systemPackages = with pkgs; [

    # IDEs / Text editors
    neovim
    vscode
    geany

    # Writings
    typst

    # Terminal emulators
    kitty
    
    # IRC-clint
    halloy    

    # Browsers
    google-chrome
    
    # Image viewer
    imv
    
    # Graphics n stuff
    inkscape

    # Media player
    mpv

    # Image / Video editors
    
    # Topbar
    waybar

    # Application launcher
    fuzzel

    #TUI/CLI-tools
    ttyper

    # Audio
    wiremix
    wireplumber
    pamixer
    
    
    #bluetooth
    
    # Clipboard
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
    wtype

    # File managers / drive mounting
    yazi
    kdePackages.dolphin
    thunar
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
    awww
    xwayland-satellite

    # Manual pages
    man-db
    

    gzdoom


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
