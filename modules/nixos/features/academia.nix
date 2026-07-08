{ pkgs, ... }:
let
  rPkgs = with pkgs.rPackages; [
    tidyverse
    ggplot2
    dplyr
    tidyr
    readr
    swirl
    rmarkdown
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
    texlive.combined.scheme-full
    texstudio
    quarto
    kdePackages.okular
    foliate
    calibre
    zettlr
    blanket    
    zotero
    neovim
    vscode
    typst
    tinymist
    typstyle
    geany
    zoom-us
  ];
}
