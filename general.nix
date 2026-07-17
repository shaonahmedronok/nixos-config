{ pkgs, ... }:
{

environment.sessionVariables = {
  NIXOS_OZONE_WL        = "1";
};


  environment.systemPackages = with pkgs; [

    kitty
    google-chrome
    nautilus
    imv
    awww
    inkscape
    mpv
    gnumake
    discord
    usbutils   # provides lsusb — needed to diagnose USB device detection
    adwaita-icon-theme
    apple-cursor
    pulseaudio      # gives pactl
    v4l-utils       # gives v4l2-ctl  
    psmisc          # gives fuser
    fuzzel
    wiremix
    wireplumber
    pamixer  
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
    wtype
    yazi
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
    ddcutil
    wlr-randr
    xdg-desktop-portal-gtk
    polkit_gnome
    qt5.qtwayland
    brightnessctl
    xwayland-satellite
       
    (pipx.overridePythonAttrs (old: {
  doCheck = false;
}))
       
    iwd
    networkmanagerapplet
    nh
    starship
    ncdu
    dysk
    gnome-disk-utility
    nix-output-monitor
    atuin
    zoxide
    fd
    ripgrep
    eza
    playerctl
    curl
    clang
    python3
    yt-dlp
    gnome-keyring
    libqalculate
    fcitx5
    fcitx5-gtk
    easyeffects
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
