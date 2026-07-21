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
    reshape2      # pivot data before tidyr; still widely used in legacy code
    viridis       # perceptually uniform color scales for ggplot2 (colorblind-safe)
    tidytext      # tidy text analysis — speeches, manifestos, political documents
    lme4          # linear mixed effects models — standard in social science panels
    forecast      # time series: election cycles, economic indicators, polling trends
    reticulate    # REQUIRED by Quarto to execute Python chunks inside .qmd files
    data_table    # data.table — fast large-dataset ops (V-Dem, ACLED have big CSVs)
    devtools      # install GitHub-only R packages at will
    magrittr      # explicit pipe %>% — sometimes needed outside tidyverse context
    styler
  ];
in
{
  environment.systemPackages = with pkgs; [
    (rWrapper.override       { packages = rPkgs; })
    (rstudioWrapper.override { packages = rPkgs; })

    pandoc
    texlive.combined.scheme-full
    python313Packages.pandas
    quarto
    zathura       # PDF reader: vim keybindings, Ctrl-R = instant dark/light toggle
    glow
    entr          # runs a command whenever a watched file changes — key for live .qmd→PDF
    xlsx2csv      # convert .xlsx to .csv for R ingestion without Excel
    img2pdf       # batch PNG → PDF (hp-scan workflow: img2pdf *.png -o output.pdf)
    graphviz      # network/relationship diagrams — useful for political network analysis
    zotero
    typst
    tinymist
    typstyle
    helix
  ];
}
