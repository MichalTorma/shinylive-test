library(shiny)
library(leaflet)

ui <- fillPage(
  title = "Fullscreen Map (Shinylive)",
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
      /* Adjust Leaflet zoom controls placement if needed */
      .leaflet-top.leaflet-left {
        top: 12px;
        left: 12px;
      }
    "))
  ),
  leafletOutput("map", width = "100%", height = "100%"),
  div(
    class = "map-overlay-card",
    h3("Interactive Map"),
    p("Client-side R Shiny app running directly in your browser using Shinylive & webR."),
    uiOutput("click_info")
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = TRUE, minZoom = 2)) |>
      addProviderTiles(providers$CartoDB.Positron, group = "CartoDB Positron") |>
      addProviderTiles(providers$OpenStreetMap, group = "OpenStreetMap") |>
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite (Esri)") |>
      setView(lng = 0, lat = 20, zoom = 3) |>
      addScaleBar(position = "bottomleft") |>
      addLayersControl(
        baseGroups = c("CartoDB Positron", "OpenStreetMap", "Satellite (Esri)"),
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
