library(shiny)
library(leaflet)

# GBIF Species Key for Reindeer / Caribou (Rangifer tarandus)
REINDEER_TAXON_KEY <- 5220114

ui <- fillPage(
  title = "Norgeskart & Reindeer Occurrences (Shinylive)",
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"),
    tags$style(HTML("
      html, body {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
        overflow: hidden;
      }
      #map {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100vw !important;
        height: 100vh !important;
      }
      .map-overlay-card {
        position: absolute;
        top: 16px;
        right: 16px;
        z-index: 1000;
        background: rgba(255, 255, 255, 0.92);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        padding: 14px 18px;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.8);
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        color: #222;
        max-width: 320px;
        pointer-events: auto;
      }
      .map-overlay-card h3 {
        margin: 0 0 6px 0;
        font-size: 15px;
        font-weight: 600;
        letter-spacing: -0.2px;
      }
      .map-overlay-card p {
        margin: 0 0 8px 0;
        font-size: 12.5px;
        color: #555;
        line-height: 1.4;
      }
      .legend-row {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 8px;
        font-size: 12px;
        color: #333;
      }
      .hex-indicator {
        width: 14px;
        height: 14px;
        background: #dc2626;
        clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
        display: inline-block;
        flex-shrink: 0;
      }
      .coordinates-badge {
        display: inline-block;
        background: #f1f5f9;
        color: #0f172a;
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 11.5px;
        font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        border: 1px solid #e2e8f0;
      }
      .leaflet-top.leaflet-left {
        top: 12px;
        left: 12px;
      }
    "))
  ),
  leafletOutput("map", width = "100%", height = "100%"),
  div(
    class = "map-overlay-card",
    h3("Reindeer Occurrences"),
    p("Norgeskart Topo with GBIF occurrence density for Rangifer tarandus."),
    div(
      class = "legend-row",
      span(class = "hex-indicator"),
      span("GBIF Occurrences (Red Hexagons)")
    ),
    uiOutput("click_info")
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    gbif_tile_url <- sprintf(
      "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?taxonKey=%d&bin=hex&hexPerTile=39&style=red.poly",
      REINDEER_TAXON_KEY
    )

    leaflet(options = leafletOptions(zoomControl = TRUE, minZoom = 2)) |>
      # Base Maps
      addTiles(
        urlTemplate = "https://cache.kartverket.no/v1/wmts/1.0.0/topo/default/webmercator/{z}/{y}/{x}.png",
        attribution = '&copy; <a href="https://www.kartverket.no/" target="_blank">Kartverket</a>',
        group = "Norgeskart Topo",
        options = tileOptions(maxZoom = 18, minZoom = 2)
      ) |>
      addTiles(
        urlTemplate = "https://cache.kartverket.no/v1/wmts/1.0.0/toporaster/default/webmercator/{z}/{y}/{x}.png",
        attribution = '&copy; <a href="https://www.kartverket.no/" target="_blank">Kartverket</a>',
        group = "Norgeskart Toporaster",
        options = tileOptions(maxZoom = 18, minZoom = 2)
      ) |>
      addTiles(
        urlTemplate = "https://cache.kartverket.no/v1/wmts/1.0.0/topograatone/default/webmercator/{z}/{y}/{x}.png",
        attribution = '&copy; <a href="https://www.kartverket.no/" target="_blank">Kartverket</a>',
        group = "Norgeskart Gr\u00e5tone",
        options = tileOptions(maxZoom = 18, minZoom = 2)
      ) |>
      addProviderTiles(providers$OpenStreetMap, group = "OpenStreetMap") |>
      # Overlays: GBIF Reindeer Occurrences (Red Hexagons)
      addTiles(
        urlTemplate = gbif_tile_url,
        attribution = '&copy; <a href="https://www.gbif.org/" target="_blank">GBIF</a>',
        group = "Reindeer (Red Hexagons)",
        options = tileOptions(opacity = 0.85, maxZoom = 18, minZoom = 0)
      ) |>
      setView(lng = 9.5, lat = 62.5, zoom = 6) |>
      addScaleBar(position = "bottomleft") |>
      addLayersControl(
        baseGroups = c("Norgeskart Topo", "Norgeskart Toporaster", "Norgeskart Gr\u00e5tone", "OpenStreetMap"),
        overlayGroups = c("Reindeer (Red Hexagons)"),
        position = "topleft",
        options = layersControlOptions(collapsed = TRUE)
      )
  })

  output$click_info <- renderUI({
    click <- input$map_click
    if (is.null(click)) {
      span(class = "coordinates-badge", "Click anywhere on the map")
    } else {
      span(
        class = "coordinates-badge",
        sprintf("Lat: %.4f, Lng: %.4f", click$lat, click$lng)
      )
    }
  })
}

shinyApp(ui = ui, server = server)
