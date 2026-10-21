#!/usr/bin/env Rscript

# scripts/dev.R
# Runs the Shiny application locally using standard Shiny server for development

if (!requireNamespace("shiny", quietly = TRUE)) {
  stop("The 'shiny' package is required. Install it via pak::pkg_install('shiny') or install.packages('shiny').")
}

message("==> Starting Shiny local development server...")
shiny::runApp("app", launch.browser = TRUE)
