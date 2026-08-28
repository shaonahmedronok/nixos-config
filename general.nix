{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus
    usbutils
    git
    google-chrome 
    adwaita-icon-theme
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
    imagemagick
    swaybg
    mako
    pulseaudio
    psmisc
    wiremix
    wireplumber
    wl-clipboard
    cliphist
    wl-clip-persist
    yazi
    udiskie
    unzip
    p7zip
    keepassxc
    slurp
    grim
    wlsunset
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    fd
    zathura
    ripgrep
    yt-dlp
    libnotify       # notify-send for all scripts
    tesseract       # OCR script
  ];

  # fileSystems."/mnt/storage" = {
    # device  = "/dev/disk/by-uuid/754d7620-c457-44ba-8a4c-b98cb493fbde";
    # fsType  = "ext4";
    # options = [ "defaults" "nofail" ];
  # };

  services.udisks2.enable               = true;
  services.avahi.enable                 = true;
  services.avahi.nssmdns4               = true;
  programs.fish.enable                  = true;

  zramSwap.enable = true;
}
