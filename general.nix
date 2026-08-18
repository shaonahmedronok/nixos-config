{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    google-chrome
    nautilus
#    inkscape
    gnumake
    usbutils   # provides lsusb — needed to diagnose USB device detection
    adwaita-icon-theme
    apple-cursor
    poppler-utils
    wtype
    imagemagick
    pulseaudio      # gives pactl
    psmisc          # gives fuser
    wiremix
    wireplumber
    pamixer  
    wl-clipboard
    cliphist
    wl-clip-persist
    xdg-terminal-exec
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
    polkit_gnome
    brightnessctl
    iwd
    networkmanagerapplet
    nh
    ncdu
    dysk
    gnome-disk-utility
    nix-output-monitor
    fd
    cpufetch
    pastel
    ripgrep
    playerctl
    clang
    yt-dlp
    libqalculate
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
