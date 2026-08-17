let
  theme = {
  base00 = "#FDF6E3";  # bg cream
  base01 = "#D9D3C3";  # selection bg
  base02 = "#D9D3C3";  # selection bg
  base03 = "#D9D3C3";  # selection bg
  base04 = "#458588";  # blue
  base05 = "#1A1A1A";  # fg black
  base06 = "#1A1A1A";  # black
  base07 = "#1A1A1A";  # black
  base08 = "#1A1A1A";  # black
  base09 = "#1A1A1A";  # black
  base0A = "#458588";  # blue
  base0B = "#1A1A1A";  # black
  base0C = "#458588";  # blue
  base0D = "#458588";  # blue
  base0E = "#458588";  # blue
  base0F = "#1A1A1A";  # black
  };
  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;
  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  inherit theme themeNoHash;
}
