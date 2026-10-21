#!/usr/bin/env Rscript

# scripts/build.R
# Exports the Shiny application in app/ to a static Shinylive bundle in docs/

if (!requireNamespace("shinylive", quietly = TRUE)) {
  stop("The 'shinylive' package is required. Install it via pak::pkg_install('shinylive') or install.packages('shinylive').")
}

app_dir <- "app"
dest_dir <- "docs"

if (!dir.exists(app_dir)) {
  stop(sprintf("Source app directory '%s' does not exist.", app_dir))
}

message(sprintf("==> Exporting '%s' to '%s' with shinylive::export()...", app_dir, dest_dir))

shinylive::export(
  appdir = app_dir,
  destdir = dest_dir,
  quiet = FALSE
)

# Create a .nojekyll file in docs/ to ensure GitHub Pages does not treat files as Jekyll site
nojekyll_file <- file.path(dest_dir, ".nojekyll")
if (!file.exists(nojekyll_file)) {
  file.create(nojekyll_file)
  message("==> Created docs/.nojekyll for GitHub Pages compatibility.")
}

message(sprintf("==> Shinylive export complete! Static files ready in '%s/'.", dest_dir))
