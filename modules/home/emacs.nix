{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ emacs-pgtk ];

services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };


  home.file.".config/doom/config.el".text = ''
    ;;; config.el -*- lexical-binding: t; -*-
    (setq user-full-name "Shaon")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14)
          doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13))
    (setq doom-theme 'catppuccin
          catppuccin-flavor 'mocha)
    (setq display-line-numbers-type 'relative)
    (setq org-directory "~/org/"
          org-agenda-files (list "~/org/"))
    (setq doom-modeline-height 28
          doom-modeline-icon t)
  '';

  home.file.".config/doom/init.el".text = ''
    ;;; init.el -*- lexical-binding: t; -*-
    (doom! :completion
           (company +childframe)
           (vertico +icons)
           :ui
           doom
           dashboard
           (emoji +unicode)
           hl-todo
           modeline
           (popup +defaults)
           workspaces
           :editor
           (evil +everywhere)
           file-templates
           fold
           snippets
           :emacs
           dired
           electric
           undo
           vc
           :term
           vterm
           :checkers
           syntax
           :tools
           (eval +overlay)
           lookup
           magit
           :lang
           emacs-lisp
           (org +pretty +roam2)
           markdown
           nix
           python
           sh
           :config
           (default +bindings +smartparens))
  '';

  home.file.".config/doom/packages.el".text = ''
    ;; -*- no-byte-compile: t; -*-
    (package! catppuccin-theme)
    (package! org-super-agenda)
  '';

  home.activation.cloneDoom = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs/.git" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 \
        https://github.com/doomemacs/doomemacs \
        "$HOME/.config/emacs"
    fi
  '';

  home.sessionVariables = {
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c";
  };
}
