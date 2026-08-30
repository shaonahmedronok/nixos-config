{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus
    adwaita-icon-theme
    git
    google-chrome 
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
    imagemagick
    swaybg
    mako
    pulseaudio
    wiremix
    wireplumber
    wl-clipboard
    cliphist
    wl-clip-persist
    yazi
    udiskie
    p7zip
    keepassxc
    slurp
    grim
    wlsunset
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    zathura
    ripgrep
    libnotify       # notify-send for all scripts
    tesseract       # OCR script
  ];

  services.udisks2.enable               = true;
  programs.fish.enable                  = true;
  zramSwap.enable = true;
}
