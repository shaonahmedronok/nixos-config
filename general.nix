{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus
    usbutils
    adwaita-icon-theme
    regreet
    cage
    apple-cursor
    wtype
    xwayland-satellite
    qt5.qtwayland
    qt6.qtwayland
    libnotify
    tesseract
    imagemagick
    swaybg
    mako
    imagemagick
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
    wf-recorder
    slurp
    grim
    wlsunset
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    ncdu
    dysk
    gnome-disk-utility
    nix-output-monitor
    fd
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
  services.power-profiles-daemon.enable = true;
  programs.fish.enable                  = true;

  zramSwap.enable = true;
}
