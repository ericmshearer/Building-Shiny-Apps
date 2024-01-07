# Building Shiny Apps Using Modules

Questions: <ericshearer@me.com>

## Getting Started

To build a shiny app, it is recommended to begin with a R project. Your
project directory will contain required sub-directories, data, and
scripts needed to build your shiny app. Large, complex apps quickly
become difficult to modify and maintain. Modules allow your app to be
broken down into smaller sections, allowing for easier maintenance and
updates.

## Load Helper Functions

To begin, load the helper functions.

``` r
source("shiny_mod_funct.R")
```

These helper functions do several things:

- `make_r_folders()` creates three sub-directories:
  - R - stores global.R plus any modules used in app.R
  - www - stores any images or .css files
  - data - stores data to be used in shiny app
- `make_r_files()` creates two core .R scripts:
  - global.R - list dependencies, parameters, bootstrap theme, load data
    files *Do not move this file*
  - app.R - primary file containing core UI and server functions *Do not
    move this file*
- `add_module()` creates a module skeleton to populate with
  inputs/outputs

## Setup

Start by running `make_r_folders()` then `make_r_files()` from the
console. In the Files window (below Global Environment), you should see
your new sub-directories.

## Build Module

To create your first module, run `add_module(id)` and specify id to name
module. This could be a plotly object, leaflet object, or an entire page
when using a navigation layout from bslib.

``` r
add_module("cd_home")
```

All of your module scripts are stored in R sub-directory. In the UI
section, add input/outputs within `tagList()`. Note in the example below
the id’s are wrapped in `ns(inputID).`

``` r
cd_home_ui <- function(id) {
  ns <- NS(id)
    tagList(
      h2("Monitoring Disease Trends in Orange County", style = "display: block; margin-left: auto; margin-right: auto;"),
      h4(paste("Data as of", week_ending), style = "display: block; margin-left: auto; margin-right: auto;"),
      hr(),
      radioButtons(inputId = ns("covid"), label = "Include COVID-19?", choices = c("Yes","No"),
                   selected = "No", inline = TRUE),
      plotlyOutput(ns("current_top_ten"), height = "525px")
    )
}

cd_home_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        
      #reactive data - show covid yes/no
      top_ten <- reactive({
        
        if(input$covid == "Yes"){
          morb_main %>%
            select(epi_year, Section, Disease, YTD) %>%
            filter(epi_year == current_year) %>%
            mutate(YTD = replace_na(YTD, 0)) %>%
            arrange(desc(YTD)) %>%
            head(10)
        } else{
          morb_main %>%
            select(epi_year, Section, Disease, YTD) %>%
            filter(epi_year == current_year, Disease != "Novel Coronavirus 2019 (nCoV-2019)") %>%
            mutate(YTD = replace_na(YTD, 0)) %>%
            arrange(desc(YTD)) %>%
            head(10)
        }
        
      })
      
      #horizontal bar plot
      output$current_top_ten <- renderPlotly({
        
        plot_ly(data = top_ten(), x = ~YTD, y = ~Disease, type = "bar", orientation = "h", text = ~as.character(YTD),
                marker = list(color = "#113a72"), textposition = "outside") %>%
          layout(
            font = list(color = "black"),
            xaxis = list(title = "Year-to-Date Cases", showgrid = FALSE, showline = TRUE, rangemode = "tozero"),
            yaxis = list(title = "", showgrid = FALSE, showline = TRUE, categoryorder = "total ascending"),
            title = paste(current_year, "- Top Ten Conditions by Counts, County of Orange"),
            margin = list(r = 25, l = 50, t = 50, b = 0),
            showlegend = FALSE
          )
      })
      
    })
}
```

## Add Modules to app.R

Once module is ready for testing/complete, add UI and server functions
to `app.R`. Note the id’s within module name have to match.

``` r
ui <- page_fluid(
  cd_home_ui("tab_1")
)


server <- function(input, output, session) {
  
  cd_home_server("tab_1")
  
}

shinyApp(ui, server)
```

## Run app.R

To launch Shiny app locally, run app.R or execute `shiny::runApp()` in
the console.
