
## https://rstudio.github.io/leaflet/shiny.html

library(shiny)
library(leaflet)
cities <- readRDS("cn_cities.rds")
cities <- cities[1:100,]

ui <- fluidPage(
    titlePanel("Top 100 Largest Cities by Population in China"),
    sidebarLayout(
        sidebarPanel(
        helpText("Display the largest cities ranked by population in China."),
        sliderInput("ui_range", 
                    label = "Range of ranks:",
                    min = 1, max = nrow(cities), value = c(1, nrow(cities)))),
    mainPanel(leafletOutput("ui_map"))))

server <- function(input, output, session) {
    filteredData <- reactive({cities[input$ui_range[1]:input$ui_range[2],]
    }) 
    output$ui_map <- renderLeaflet({
        cities %>% leaflet() %>% addTiles() %>% 
            fitBounds(~min(lng), ~min(lat), ~max(lng), ~max(lat))
    })
    observe({
      leafletProxy("ui_map", data=filteredData()) %>%
        clearShapes() %>%
        addCircles(weight=1, color="#49b2b2", radius=~sqrt(population)*50)
    })
}

shinyApp(ui, server)