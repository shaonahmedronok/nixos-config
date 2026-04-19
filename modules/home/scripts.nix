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
      if pgrep -x wlsunset > /dev/null; then
        pkill wlsunset
      else
        wlsunset -t 4500 -T 4500 &
      fi
      # bash built-in kill understands SIGRTMIN arithmetic reliably
      pkill -RTMIN+8 -f waybar 2>/dev/null || true
    '';
  };

  home.file."~/dirrr/wallpapers/cycle-wallpaper.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      WALLPAPER_DIR="$HOME/dirrr/wallpapers"
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n 1)
      swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    '';
  };
}
