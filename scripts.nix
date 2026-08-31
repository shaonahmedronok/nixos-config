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
        grim -g "$(slurp)" "$SCREENSHOT_DIR/ss$n.png" || exit 0
      else
        grim "$SCREENSHOT_DIR/ss$n.png"
      fi
      wl-copy < "$SCREENSHOT_DIR/ss$n.png"
      notify-send -i "$SCREENSHOT_DIR/ss$n.png" "📸 Screenshot" "Saved: ss$n.png — copied to clipboard" -t 3000
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
      notify-send "🌡 Colour Temp" "''${NEW}K" -t 1200
    '';
  };

  home.file.".local/bin/volume-control.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      # Wait for wireplumber to be ready (max 5s, non-blocking after first boot)
      timeout=5
      while [ $timeout -gt 0 ]; do
        pactl info &>/dev/null && break
        sleep 0.5
        timeout=$((timeout - 1))
      done

      case "$1" in
        up)   pactl set-sink-volume @DEFAULT_SINK@ +2% ;;
        down) pactl set-sink-volume @DEFAULT_SINK@ -2% ;;
        mute) pactl set-sink-mute  @DEFAULT_SINK@ toggle ;;
      esac

      MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -c "yes")
      VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

      if [ "$MUTED" -gt 0 ]; then
        notify-send -h string:x-canonical-private-synchronous:volume \
          "🔇 Muted" "" -t 1000
      else
        notify-send -h string:x-canonical-private-synchronous:volume \
          -h "int:value:$(echo $VOL | tr -d '%')" \
          "🔊 Volume" "$VOL" -t 1000
      fi
    '';
  };

  home.file.".local/bin/system-status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      MEM=$(free -h | awk '/^Mem:/ {print $3"/"$2}')
      DISK=$(df -h / | awk 'NR==2{print $3"/"$2" ("$5")"}')
      UPTIME=$(uptime -p | sed 's/up //')
      CPU_LOAD=$(uptime | grep -oP 'load average: \K[^,]+')
      CPU_TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | \
        awk '{sum+=$1; n++} END {if(n>0) printf "%.0f°C", sum/n/1000; else print "n/a"}')
      notify-send "💻 System" \
        "RAM:    $MEM
Disk:   $DISK
Load:   $CPU_LOAD
Temp:   $CPU_TEMP
Uptime: $UPTIME" -t 6000
    '';
  };

home.file.".local/bin/wallpaper-cycle.sh" = {
  executable = true;
  text = ''
    #!/bin/bash
WALLDIR="$HOME/dirrr/wallpapers"
STORE="$HOME/.current_wallpaper"

# Get all images
mapfile -t WALLS < <(find "$WALLDIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

if [ ''${#WALLS[@]} -eq 0 ]; then
  notify-send "🖼 Wallpaper" "No images found in ~/dirrr/wallpapers" -t 2000
  exit 1
fi

# Get current index
CURRENT=$(cat "$STORE" 2>/dev/null || echo "-1")
NEXT=$(( (CURRENT + 1) % ''${#WALLS[@]} ))
echo "$NEXT" > "$STORE"

WALL="''${WALLS[$NEXT]}"
pkill swaybg 2>/dev/null
sleep 0.1
swaybg -i "$WALL" -m fill &
notify-send "🖼 Wallpaper" "$(basename $WALL)" -t 1500
  '';
};

  home.file.".local/bin/network-status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      IFACE=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\S+' | head -1)
      IP=$(ip addr show "$IFACE" 2>/dev/null | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | head -1)
      SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
      PING=$(ping -c1 -W1 8.8.8.8 2>/dev/null | grep -oP 'time=\K[\d.]+' | head -1)

      if [ -n "$SSID" ]; then
        notify-send "🌐 Network" "WiFi: $SSID
IP:   ${IP:-unknown}
Ping: ${PING:-timeout}ms" -t 4000
      elif [ -n "$IP" ]; then
        notify-send "🌐 Network" "Ethernet: $IP
Ping: ${PING:-timeout}ms" -t 4000
      else
        notify-send "🌐 Network" "No connection" -t 4000
      fi
    '';
  };

  home.file.".local/bin/audio-info.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      SINK=$(pactl info | grep "Default Sink" | cut -d: -f2 | xargs | sed 's/.*\.//')
      VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
      MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(yes|no)')
      SOURCE=$(pactl info | grep "Default Source" | cut -d: -f2 | xargs | sed 's/.*\.//')
      notify-send "🔊 Audio" "Out: $SINK
Vol: $VOL (muted: $MUTED)
In:  $SOURCE" -t 4000
    '';
  };

  home.file.".local/bin/show-datetime.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      DATE=$(date "+%A, %d %B %Y")
      TIME=$(date "+%H:%M:%S")
      WEEK=$(date "+Week %V")
      notify-send "🕐 Time" "$TIME
$DATE
$WEEK" -t 4000
    '';
  };

  home.file.".local/bin/ocr-extract.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      TMPIMG=$(mktemp /tmp/ocr-XXXXXX.png)
      grim -g "$(slurp)" "$TMPIMG" || { rm -f "$TMPIMG"; exit 0; }
      TEXT=$(tesseract "$TMPIMG" stdout 2>/dev/null | tr -d '\f')
      rm -f "$TMPIMG"
      if [ -n "$TEXT" ]; then
        echo "$TEXT" | wl-copy
        notify-send "📋 OCR" "Text copied to clipboard" -t 2000
      else
        notify-send "📋 OCR" "No text found" -t 2000
      fi
    '';
  };

  home.file.".local/bin/color-pick.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      TMPIMG=$(mktemp /tmp/colorpick-XXXXXX.png)
      grim -g "$(slurp -p)" "$TMPIMG" 2>/dev/null || { rm -f "$TMPIMG"; exit 0; }
      HEX=$(convert "$TMPIMG" -format "#%[hex:u.p{0,0}]" info: 2>/dev/null | head -c 7)
      rm -f "$TMPIMG"
      if [ -n "$HEX" ]; then
        echo "$HEX" | wl-copy
        notify-send "🎨 Colour" "$HEX — copied to clipboard" -t 2500
      fi
    '';
  };

  home.file.".local/bin/keybinds-cheatsheet.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      CHEATSHEET=$(cat << 'KEYS'
      ── Apps ──────────────────────────────
      Mod+Return          Terminal (Alacritty)
      Mod+Space           App launcher (fuzzel)
      Mod+B               Google Chrome
      Mod+V               Clipboard history
      ── Windows ───────────────────────────
      Mod+C               Close window
      Mod+F               Maximize column
      Mod+Shift+Space     Toggle floating
      ── Focus ─────────────────────────────
      Mod+H/J/K/L         Focus left/down/up/right
      Mod+Arrows          Focus (arrow keys)
      ── Move ──────────────────────────────
      Mod+Shift+H/J/K/L   Move window
      Mod+Shift+Arrows    Move window
      Mod+Shift+,/.       Move to monitor left/right
      ── Workspaces ────────────────────────
      Mod+1-9             Switch workspace
      Mod+Shift+1-9       Move window to workspace
      ── Screenshot ────────────────────────
      Mod+Z               Region screenshot
      Mod+Shift+Z         Full screenshot
      ── Audio ─────────────────────────────
      Mod+F1              Mute toggle
      Mod+F2              Volume -5%
      Mod+F3              Volume +5%
      Knob turn           Volume ±2% (AK820)
      Knob press          Mute toggle (AK820)
      ── Colour temp ───────────────────────
      Mod+Alt+Up          Warmer (+200K)
      Mod+Alt+Down        Cooler (-200K)
      Mod+Shift+W         Toggle night mode
      ── Info popups ───────────────────────
      Alt+T               Date & time
      Alt+S               System status
      Alt+N               Network status
      Alt+A               Audio info
      Alt+K               THIS cheatsheet
      ── Language & Input ────────────────────────────
      Ctrl+Space          Change system keyboard layout
      ── Screen ────────────────────────────
      Mod+O               OCR (copy text from screen)
      Mod+P               Colour picker
      ── Session ───────────────────────────
      Mod+Shift+X         Lock screen (hyprlock)
      Mod+Shift+E         Quit niri
      KEYS
      )
      echo "$CHEATSHEET" | fuzzel --dmenu \
        --prompt="  Keybinds — Esc to close  " \
        --lines=22 \
        --width=44 \
        --no-exit-on-keyboard-focus-loss
    '';
  };
}
