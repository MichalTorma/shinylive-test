#!/usr/bin/env Rscript

# scripts/serve.R
# Starts a local web server to preview the docs/ folder

port_env <- Sys.getenv("PORT", "8008")
port <- as.integer(port_env)
docs_dir <- normalizePath("docs", mustWork = FALSE)

if (!dir.exists(docs_dir)) {
  stop("The 'docs/' directory does not exist. Run 'Rscript scripts/build.R' first.")
}

message(sprintf("==> Serving '%s' at http://127.0.0.1:%d", docs_dir, port))
message("==> Press Ctrl+C to stop the server.")

if (requireNamespace("httpuv", quietly = TRUE)) {
  httpuv::runStaticServer(
    dir = docs_dir,
    port = port,
    browse = TRUE
  )
} else {
  message("Note: 'httpuv' package not found, falling back to python3 http.server...")
  system2("python3", c("-m", "http.server", as.character(port), "--directory", docs_dir))
}
