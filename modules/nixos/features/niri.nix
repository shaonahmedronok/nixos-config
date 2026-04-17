{ pkgs, ... }:
{
  programs.niri.enable = true;

  # Required for apps that link against GTK and need X11 fallback
  # (KeepassXC, Inkscape, etc.)
  programs.xwayland.enable = true;

  xdg.portal = {
    enable       = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
