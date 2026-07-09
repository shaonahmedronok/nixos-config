//====================================
// Cheat-Sheet
// ===================================

#set document(
  title: "Cheat-Sheet",
  author: "Shaon",
)

// theme ======
#let base00 = rgb("#242424") // bg
#let base01 = rgb("#3c3836") // surface
#let base02 = rgb("#504945") // surface2
#let base03 = rgb("#665c54") // muted
#let base04 = rgb("#bdae93") // subtle
#let base05 = rgb("#d5c4a1") // text soft
#let base06 = rgb("#ebdbb2") // text
#let base07 = rgb("#fbf1c7") // text bright
#let base08 = rgb("#7daea3") // red
#let base09 = rgb("#7daea3") // orange
#let base0A = rgb("#7daea3") // yellow — H1
#let base0B = rgb("#e089a1") // green — accents
#let base0C = rgb("#7daea3") // cyan — H3
#let base0D = rgb("#7daea3") // blue — H2
#let base0E = rgb("#7daea3") // magenta
#let base0F = rgb("#7daea3") // orange2
#let wm = rgb("#2e2b28") // subtle watermark












#page(fill: base00, margin: 0pt)[

  // ── SUBTLE CORNER MARKS (4 only — minimal) ──
  #place(top + left, dx: 18pt, dy: 24pt)[
    #text(fill: wm, size: 44pt, font: ("JetBrainsMono NF",))[✦]]
  #place(top + right, dx: -22pt, dy: 20pt)[
    #text(fill: wm, size: 36pt, font: ("JetBrainsMono NF",))[✎]]
  #place(bottom + left, dx: 18pt, dy: -44pt)[
    #text(fill: wm, size: 38pt, font: ("JetBrainsMono NF",))[✎]]
  #place(bottom + right, dx: -22pt, dy: -40pt)[
    #text(fill: wm, size: 42pt, font: ("JetBrainsMono NF",))[✦]]

  // ── LEFT ACCENT STRIP ──
  #place(top + left, dx: 0pt, dy: 0pt)[
    #block(width: 5pt, height: 100%, fill: base0B)[]
  ]
  #place(top + left, dx: 5pt, dy: 0pt)[
    #block(width: 1.5pt, height: 100%, fill: base0D)[]
  ]

  // ── RIGHT ACCENT STRIP ──
  #place(top + right, dx: 0pt, dy: 0pt)[
    #block(width: 5pt, height: 100%, fill: base0B)[]
  ]

  // ── TOP LINE ──
  #place(top + left, dx: 0pt, dy: 0pt)[
    #block(width: 100%, height: 4pt, fill: base0B)[]
  ]

  // ── BOTTOM LINE ──
  #place(bottom + left, dx: 0pt, dy: 0pt)[
    #block(width: 100%, height: 4pt, fill: base0B)[]
  ]

  // ── MAIN CONTENT ──
  #align(center + horizon)[
    #pad(x: 72pt)[

      #text(
        fill: base09,
        size: 7.5pt,
        weight: "bold",
        tracking: 8pt,
        font: ("JetBrainsMono NF",),
      )[]

      #v(48pt)

      #text(
        fill: base0A,
        weight: "bold",
        size: 64pt,
        tracking: -1pt,
        font: ("JetBrainsMono NF",),
      )[Cheat-Sheet]

      #v(16pt)

      #line(length: 60%, stroke: 0.8pt + base03)

      #v(16pt)

      #text(
        fill: base0D,
        weight: "bold",
        size: 11pt,
        tracking: 7pt,
        font: ("JetBrainsMono NF",),
      )[Fun n Easy]

      #v(10pt)

      #text(
        fill: base04,
        size: 9pt,
        style: "italic",
        font: ("JetBrainsMono NF",),
      )[]

      #v(64pt)

    ]
  ]

]
// ── END COVER PAGE ────────────────────────────────────────

#pagebreak()

// ── BODY PAGES ────────────────────────────────────────────
#set page(
  paper: "a4",
  fill: base00,
  margin: (x: 2.4cm, y: 2.2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: 1fr,
        align(center)[
          #text(fill: base0B, weight: "bold", size: 8pt, font: (
            "JetBrainsMono NF",
          ))[Cheat-Sheet]
        ],
      )
      line(length: 100%, stroke: 0.4pt + base02)
    }
  },
  footer: context {
    line(length: 100%, stroke: 0.4pt + base02)
    v(3pt)
    grid(
      columns: (1fr, 1fr, 1fr),
      align(left)[
        #text(size: 7pt, fill: base03, font: (
          "JetBrainsMono NF",
        ))[STUDY ABROAD]
      ],
      align(center)[
        #text(fill: base09, size: 7.5pt, font: (
          "JetBrainsMono NF",
        ))[— #counter(page).display() —]
      ],
      align(right)[
        #text(size: 7pt, fill: base03, font: (
          "JetBrainsMono NF",
        ))[BEYOND NEEDS]
      ],
    )
  },
)

// ── TYPOGRAPHY ────────────────────────────────────────────
#set text(
  font: ("JetBrainsMono NF",),
  size: 10.5pt,
  fill: base06, // #ebdbb2 — proper Gruvbox fg
  lang: "en",
  hyphenate: true,
)

#set par(
  justify: true,
  leading: 0.95em,
  spacing: 1.1em,
)

// H1 — yellow + rule
#show heading.where(level: 1): it => {
  v(1.6em)
  block(breakable: false)[
    #text(
      fill: base0A,
      weight: "bold",
      size: 14pt,
      font: ("JetBrainsMono NF",),
    )[#it.body]
    #v(0.25em)
    #line(length: 100%, stroke: 0.8pt + base02)
  ]
  v(0.6em)
}

// H2 — blue
#show heading.where(level: 2): it => {
  v(1.1em)
  block(breakable: false)[
    #text(
      fill: base0D,
      weight: "bold",
      size: 12pt,
      font: ("JetBrainsMono NF",),
    )[#it.body]
  ]
  v(0.3em)
}

// H3 — cyan
#show heading.where(level: 3): it => {
  v(0.8em)
  block(breakable: false)[
    #text(
      fill: base0C,
      weight: "bold",
      size: 10.5pt,
      font: ("JetBrainsMono NF",),
    )[#it.body]
  ]
  v(0.2em)
}









= LaTeX and Typst workflow

== LaTeX


#v(2.2em)

// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF", size: 13pt)

```
$ latexmk -pvc -pdf -view=none test1.tex
```


#v(0.7em)


// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF")

```
$ zathura file-name.pdf &
```





== Typst


#v(2.2em)

// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF")

```
$ typst watch file-name.typ
```

#v(0.7em)

// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF")

```
$ zathura file-name.pdf &
```



#pagebreak()















= NixOS commands

== Daily use (after any edit):



#v(1.1em)


// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF", size: 13pt)

```
cd /etc/nixos
# edit whatever file
git add .
sudo nixos-rebuild switch --flake /etc/nixos#nixos
git commit -m "what changed"
git push
```

#v(2.7em)



== Daily use (after any edit):



#v(1.1em)

// Style only block-level code blocks
#show raw.where(block: true): set block(
  //fill: rgb("#e089a1"),
  inset: 10pt,
  radius: 4pt,
  stroke: 1pt + rgb("#e089a1"),
)

// Optional: Change the font color of the code text globally
#show raw: set text(fill: rgb("#ebdbb2"), font: "JetBrainsMono NF")

```
cd /etc/nixos
sudo nix flake update
git add .
sudo nixos-rebuild switch --flake /etc/nixos#nixos
nh clean all --keep 3
git commit -m "update"
git push
```



