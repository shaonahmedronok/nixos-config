{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zathura
    img2pdf
  ];
}
