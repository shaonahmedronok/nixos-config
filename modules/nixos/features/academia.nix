{ pkgs, ... }:
let
  rPkgs = with pkgs.rPackages; [
    tidyverse
    ggplot2
    dplyr
    rmarkdown
    knitr
    tinytex
    devtools
    languageserver
    lintr
    haven
    styler
  ];
in
{
  environment.systemPackages = with pkgs; [
    (rWrapper.override       { packages = rPkgs; })
    (rstudioWrapper.override { packages = rPkgs; })

    pandoc
    texlive.combined.scheme-small
    quarto
    onlyoffice-desktopeditors
    kdePackages.okular
    foliate
    calibre
    zettlr
    xclip
    blanket    
    zotero
    neovim
    vscode
    typst
    geany
    zoom-us
    xournalpp
    obsidian
  ];
}
