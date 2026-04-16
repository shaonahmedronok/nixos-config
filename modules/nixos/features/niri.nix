{ pkgs, ... }:
{
  # Enable the Niri compositor (Rust-based)
  programs.niri.enable = true;

  # Portals for screen sharing/file picking
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome # Better compatibility for Niri
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
