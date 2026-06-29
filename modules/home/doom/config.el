;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Shaon")

(setq doom-font              (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13)
      doom-big-font          (font-spec :family "JetBrainsMono Nerd Font Mono" :size 24))

(setq doom-theme        'catppuccin
      catppuccin-flavor 'mocha)

(setq display-line-numbers-type 'relative)

(setq org-directory    "~/org/"
      org-agenda-files (list "~/org/")
      org-agenda-span  'week
      org-agenda-start-on-weekday 0)

(after! org
  (setq org-ellipsis          " ▾"
        org-hide-leading-stars t
        org-tags-column        -80))

(setq doom-modeline-height 28
      doom-modeline-icon   t)
