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





home.file.".local/bin/wlsunset-adjust.sh" = {
  executable = true;
  text = ''
    #!/bin/bash
    STEP=200
    STORE="$HOME/.wlsunset_temp"
    [ -f "$STORE" ] && CURRENT=$(cat "$STORE") || CURRENT=3000

    case "$1" in
      up)   NEW=$((CURRENT + STEP)) ;;
      down) NEW=$((CURRENT - STEP)) ;;
      *)    NEW=$CURRENT ;;
    esac

    [ "$NEW" -lt 1000 ] && NEW=1000
    [ "$NEW" -gt 6500 ] && NEW=6500

    echo "$NEW" > "$STORE"
    pkill wlsunset 2>/dev/null
    sleep 0.2
    setsid wlsunset -t "$NEW" -T $((NEW + 1)) -l 90 -L 0 >/dev/null 2>&1 &
    notify-send "🌡 wlsunset" "''${NEW}K" -t 1200
  '';
};
}
