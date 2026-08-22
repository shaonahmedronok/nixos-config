let
  theme = {
  base00 = "#FDF6E3";  # bg cream                         — UNCHANGED
  base01 = "#D9D3C3";  # selection bg / panel bg           — UNCHANGED
  base02 = "#D9D3C3";  # active line bg                    — UNCHANGED
  base03 = "#999999";  # comments / dim ui separators      — WAS #D9D3C3 (invisible on base01 bg)
  base04 = "#8B7355";  # dark fg / status subtext (brown)  — WAS #458588 (wrong semantic slot)
  base05 = "#000000";  # primary fg                        — WAS #1A1A1A
  base06 = "#000000";  # emphasized fg                     — WAS #1A1A1A
  base07 = "#000000";  # brightest fg                      — WAS #1A1A1A
  base08 = "#CC3333";  # RED  — errors, cuts, write-perm   — WAS #1A1A1A (broken: black ≠ red)
  base09 = "#C67F3A";  # AMBER — dirs, timestamps, .rs     — WAS #1A1A1A (broken: black ≠ orange)
  base0A = "#9A7D0A";  # GOLD — warnings, .py, .json       — WAS #458588 (wrong: teal ≠ yellow)
  base0B = "#458588";  # TEAL — active/hovered/cwd/strings — WAS #1A1A1A (broken: most-used slot, 17×)
  base0C = "#2E8B84";  # DEEP TEAL — cyan/interpolation    — WAS #458588 (slight refinement)
  base0D = "#458588";  # TEAL/BLUE — border/selected/prog  — UNCHANGED
  base0E = "#e089a1";  # MAGENTA/PINK                      — WAS #458588 (wrong: teal ≠ magenta)
  base0F = "#8B7355";  # BROWN — special/deprecated        — WAS #1A1A1A (broken)
  };
  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;
  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  inherit theme themeNoHash;
}
