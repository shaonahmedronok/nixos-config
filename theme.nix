let
  theme = {
    base00 = "#242424"; # bg
    base01 = "#3c3836"; # dark
    base02 = "#504945";
    base03 = "#665c54";
    base04 = "#bdae93";
    base05 = "#d5c4a1";
    base06 = "#ebdbb2"; # fg
    base07 = "#ebdbb2"; # light fg (using fg)
    base08 = "#e089a1"; # red (using magenta)
    base09 = "#7daea3"; # orange (using blue)
    base0A = "#e089a1"; # yellow (using magenta)
    base0B = "#7daea3"; # green (using blue)
    base0C = "#7daea3"; # cyan (using blue)
    base0D = "#7daea3"; # blue
    base0E = "#e089a1"; # magenta
    base0F = "#e089a1"; # orange2 (using magenta)
  };
  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;
  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  inherit theme themeNoHash;
}
