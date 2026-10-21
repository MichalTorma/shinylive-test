.PHONY: all dev build serve clean install

# Default action: build static site
all: build

# Install required R dependencies
install:
	Rscript -e 'if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak"); pak::pkg_install(c("shiny", "shinylive", "leaflet", "httpuv"))'

# Run the app locally in standard Shiny mode for development
dev:
	Rscript scripts/dev.R

# Build/export the app into docs/ via Shinylive
build:
	Rscript scripts/build.R

# Serve the static docs/ folder locally for previewing
serve:
	Rscript scripts/serve.R

# Clean built assets in docs/
clean:
	rm -rf docs
