#set page(fill: rgb("#242424"))

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 8 — HYPRLAND KEYBINDS
// ─────────────────────────────────────────────────────────────────────────────
//
//
#let base00 = rgb("#242424") // The Body color
#let base01 = rgb("#3c3836") // The Box color (Dark Grey)
#let base05 = rgb("#d5c4a1") // The Text color (Beige)
#let base0B = rgb("#ebdbb2") // The Heading color (Greenish/Yellow)
#let base03 = rgb("#665c54") // The Box Border color
//
//
#block(height: 0pt)[] <sec-8>


#align(center)[
#text(fill: rgb("#b8bb26"), size: 24pt, weight: "bold")[Hyprland Keybinds]
]

#v(0.3cm)

#block(
  fill: base01,
  inset: 9pt,
  radius: 11pt,
  width: 100%,
)[
  #set text(fill: base05, font: "JetBrainsMono NF", size: 14pt)
```bash
Super + Return          Open terminal (alacritty)
Super + grave           Open terminal (alacritty)
Super + Space           App launcher (fuzzel)
Super + B               Chromium
Super + E               Nautilus file manager
Super + C               Kill active window
Super + F               Toggle fullscreen
Super + Shift + Space   Toggle float
Super + V               Clipboard history (cliphist)
Super + period          Emoji picker
Super + Z               Screenshot region
Super + Shift + Z       Screenshot full
Super + Shift + X       Lock screen (swaylock)
Super + Shift + L       Lock screen
Super + N               Dismiss notification
Super + Shift + N       Dismiss all notifications
Super + Shift + E       Exit Hyprland

Super + H/J/K/L         Focus window left/down/up/right
Super + arrows          Focus window (arrow keys)
Super + Shift + H/J/K/L Move window left/down/up/right
Super + 1-9             Switch to workspace 1-9
Super + Shift + 1-9     Move window to workspace 1-9
Super + Shift + period  Move to next monitor
Super + Shift + comma   Move to previous monitor

Super + mouse drag      Move window
Super + right-click     Resize window

Super + Page_Up         Brightness up (ddcutil)
Super + Page_Down       Brightness down (ddcutil)
Super + F1              Mute audio
Super + F2              Volume down
Super + F3              Volume up
```
]

#v(0.7cm)
