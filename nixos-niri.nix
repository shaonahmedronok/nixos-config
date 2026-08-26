{ pkgs, ... }:
{
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  xdg.portal = {
    enable       = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default                                      = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast"    = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot"    = [ "gnome" ];
    };
  };
}
