# Shinylive R Fullscreen Map Scaffold

A template and workflow for building and deploying serverless [R Shiny](https://shiny.posit.co/) applications running entirely client-side in the browser via [Shinylive](https://posit-dev.github.io/r-shinylive/) and [webR](https://docs.r-wasm.org/webr/latest/).

The application is compiled into static HTML, JavaScript, and WebAssembly in the `docs/` folder, making it directly hostable on **GitHub Pages** (or any static web host like Netlify, Vercel, Cloudflare Pages, S3).

---

## 📁 Project Structure

```text
├── .github/
│   └── workflows/
│       └── deploy.yml        # Automated GitHub Actions build & deploy to Pages
├── app/
│   └── app.R                 # Shiny application (fullscreen Leaflet map)
├── docs/                     # Static Shinylive bundle (served by GitHub Pages)
│   ├── .nojekyll             # Prevents GitHub Pages Jekyll processing
│   ├── index.html            # Static web runner
│   └── ...                   # WebR, Shinylive assets, & app code
├── scripts/
│   ├── build.R               # Exports app/ to docs/ via shinylive::export()
│   ├── dev.R                 # Runs app locally using standard Shiny
│   └── serve.R               # Local static HTTP server for previewing docs/
├── DESCRIPTION               # R package & dependency declarations
├── Makefile                  # Developer CLI shortcuts
├── .gitignore                # R & git hygiene rules
└── README.md                 # Project documentation
```

---

## 🚀 Quick Start

### 1. Prerequisites

Ensure you have R (>= 4.1.0) installed. Install required packages using `pak` or standard `install.packages()`:

```bash
make install
# Or in R:
# pak::pkg_install(c("shiny", "shinylive", "leaflet", "httpuv"))
```

### 2. Local Shiny Development

Run the app locally with the standard Shiny reactive engine for fast iteration and debugging:

```bash
make dev
# Or: Rscript scripts/dev.R
```

### 3. Build Static Site for GitHub Pages

Export the application to the `docs/` directory:

```bash
make build
# Or: Rscript scripts/build.R
```

This bundles:
- The WebR runtime and Shinylive engine into `docs/`
- Precompiled WebAssembly package dependencies (e.g. `{shiny}`, `{leaflet}`)
- The Shiny application code into `docs/app.json`
- A `.nojekyll` file so GitHub Pages serves WebAssembly without interference

### 4. Preview Static Site Locally

Because WebAssembly and Web Workers require proper HTTP origin handling, preview the static bundle using the local server:

```bash
make serve
# Or: Rscript scripts/serve.R
```

Navigate to `http://127.0.0.1:8008` in your browser.

---

## 🌐 Deploying to GitHub Pages

You can deploy to GitHub Pages using either of two methods:

### Method A: Direct `/docs` Folder (Simplest)

1. Commit and push the repo including the `docs/` folder to GitHub.
2. In your GitHub repository, navigate to **Settings** > **Pages**.
3. Under **Build and deployment**:
   - **Source**: Select `Deploy from a branch`.
   - **Branch**: Select `main` (or `master`) and specify the `/docs` folder.
4. Click **Save**. Within a minute, your app will be live at `https://<username>.github.io/<repo>/`!

### Method B: GitHub Actions (Automated CI/CD)

The repo includes [.github/workflows/deploy.yml](.github/workflows/deploy.yml):

1. In your GitHub repository, navigate to **Settings** > **Pages**.
2. Under **Build and deployment**:
   - **Source**: Select `GitHub Actions`.
3. Every push to `main` will automatically build the latest Shinylive assets and deploy them.

---

## 🗺️ What's in the App

The current scaffold provides a fullscreen Leaflet map featuring:
- Full viewport responsiveness (`100vw` / `100vh`) with no browser scrollbars
- Multiple tile providers with layer switching (CartoDB Positron, OpenStreetMap, Esri World Imagery)
- Interactive click feedback displaying latitude & longitude coordinates
- Scale bar and responsive navigation controls
- Modern glassmorphism floating info panel
