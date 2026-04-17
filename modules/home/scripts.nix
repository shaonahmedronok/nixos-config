{ ... }:
{
  home.file.".local/bin/screenshot-capture-wayland.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      SCREENSHOT_DIR="$HOME/dirrr"
      LOCKFILE="$HOME/.ss_counter.lock"
      mkdir -p "$SCREENSHOT_DIR"
      exec 200>"$LOCKFILE"
      flock 200
      n=1
      while [ -f "$SCREENSHOT_DIR/ss$n.png" ]; do
        n=$((n + 1))
      done
      if [ "$1" = "region" ]; then
        grim -g "$(slurp)" "$SCREENSHOT_DIR/ss$n.png"
      else
        grim "$SCREENSHOT_DIR/ss$n.png"
      fi
    '';
  };

  home.file.".local/bin/wlsunset-toggle.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      if pgrep -x hyprsunset > /dev/null; then
        pkill hyprsunset
      else
        hyprsunset -t 4500 &
      fi
      pkill --signal SIGRTMIN+8 waybar
    '';
  };

  home.file.".config/hypr/cycle-wallpaper.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n 1)
      swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    '';
  };
}
