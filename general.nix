{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    google-chrome
    nautilus
#    inkscape
    usbutils   # provides lsusb — needed to diagnose USB device detection
    adwaita-icon-theme
    apple-cursor
    wtype
    imagemagick
    pulseaudio      # gives pactl
    psmisc          # gives fuser
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
    mako
    slurp
    grim
    wlsunset
    btop  
    ddcutil
    polkit_gnome
    networkmanagerapplet
    nh
    ncdu
    dysk
    gnome-disk-utility
    nix-output-monitor
    fd
    cpufetch
    ripgrep
    yt-dlp
  ];


  fileSystems."/mnt/storage" = {
  device = "/dev/disk/by-uuid/754d7620-c457-44ba-8a4c-b98cb493fbde";
  fsType = "ext4";
  options = [ "defaults" "nofail" ];
};

  services.udisks2.enable             = true;
  services.avahi.enable               = true;
  services.avahi.nssmdns4             = true;
  services.power-profiles-daemon.enable = true;
  programs.fish.enable = true;

  zramSwap.enable           = true;
}
