{ pkgs, ... }:
{

environment.sessionVariables = {
  NIXOS_OZONE_WL        = "1";
};


  environment.systemPackages = with pkgs; [

    kitty
    google-chrome
    imv
    inkscape
    mpv
    waybar
    fuzzel
    ttyper
    wiremix
    wireplumber
    pamixer  
    discord
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
    wtype
    yazi
    kdePackages.dolphin
    thunar
    udiskie
    unzip
    p7zip
    keepassxc
    mako
    libnotify
    slurp
    grim
    ffmpeg
    wf-recorder
    wlsunset
    btop
    fastfetch
    ddcutil
    wlr-randr
    hypridle
    xdg-desktop-portal-gtk
    polkit_gnome
    qt5.qtwayland
    brightnessctl
    awww
    tree
    xwayland-satellite
    man-db
   
    (pipx.overridePythonAttrs (old: {
  doCheck = false;
}))
   
    
    iwd
    networkmanagerapplet
    nh
    bat
    starship
    ncdu
    gnome-disk-utility
    localsend
    nix-output-monitor
    tlrc
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
  services.stirling-pdf.enable = true;
  services.avahi.enable               = true;
  services.avahi.nssmdns4             = true;
  services.power-profiles-daemon.enable = true;
  programs.fish.enable = true;

  zramSwap.enable           = true;
}
