if(T){
  metanr_packages <- function(){
    metr_pkgs <-
      c(
        "impute",
        "pcaMethods",
        "globaltest",
        "GlobalAncova",
        "Rgraphviz",
        "preprocessCore",
        "genefilter",
        "SSPA",
        "sva",
        "limma",
        "KEGGgraph",
        "siggenes",
        "BiocParallel",
        "MSnbase",
        "multtest",
        "RBGL",
        "edgeR",
        "fgsea",
        "devtools",
        "crmn"
      )
    list_installed <- installed.packages()
    new_pkgs <- subset(metr_pkgs, !(metr_pkgs %in% list_installed[, "Package"]))
    if(length(new_pkgs)!=0){if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
      BiocManager::install(new_pkgs)
      print(c(new_pkgs, " packages added..."))
    }
    
    if((length(new_pkgs)<1)){
      print("No new packages added...")
    }
  }
  # get required deps
  metanr_packages()
  # install metaboAnalystR itself.
  devtools::install_github(
    "xia-lab/MetaboAnalystR",
    build = TRUE,
    build_vignettes = F,
    force=T
  )
}
library(MetaboAnalystR)
