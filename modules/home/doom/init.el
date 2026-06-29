;;; init.el -*- lexical-binding: t; -*-
(doom! :completion
       (company +childframe)
       (vertico +icons)

       :ui
       doom
       dashboard
       (emoji +unicode)
       hl-todo
       indent-guides
       modeline
       (popup +defaults)
       (vc-gutter +pretty)
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets

       :emacs
       dired
       electric
       (ibuffer +icons)
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
