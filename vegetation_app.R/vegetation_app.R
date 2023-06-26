# App Library 
library(tidyverse)
library(shiny)
library(leaflet)

# Load data
vegetation_surveys <- read_csv(here::here("data/clean_data/vegetation_surveys.csv"))

ui <- fluidPage(
  navbarPage(
    title = "Peatland Action - Vegetation Survey Results",
    
    # About tab
    tabPanel("About",
             h2("Why are these data collected?"),
             p("The effectiveness of Peatland Action restoration activities was assessed by monitoring 
               vegetation and other environmental variables. 
               These surveys were carried out on Peatland Action sites in 2014 and 2015 to amass a baseline 
               dataset, and again in 2021 to investigate the changes in the intervening period. 
               Sites were selected to include raised bog and blanket bog, and encompassed a range of bog 
               vegetation types and restoration approaches."),
             h2("How much data is there?"),
             p("A total of 1,002 quadrats on 16 sites were surveyed for the baseline survey, 
               and 873 quadrats on 13 sites were surveyed in the repeat survey. 
               The sample areas included restored areas, unrestored control areas and unmodified 
               reference areas. The raw datasets can be downloaded from the report appendices. 
               Appendix 2B in the repeat survey (2021) contains the data from both surveys with one row per 
               replicate (quadrat). 
               The simplified raw data from both surveys is formatted as one row per record."),
             h2("Who is this data for"),
             p("Peatland ACTION Project Officers - viewing and accessing site specific data to understand 
               the effect of restoration works.
               
               Landowners - out of interest looking at their sites. 
               
               Volunteers/groups - viewing site specific data to understand the effect of restoration 
               works and out of interest looking at their sites.
               
               Researchers - access to the data to support their own projects. 
               
               NatureScot staff (e.g. reserve manager, wetland advisor) - viewing and accessing site 
               specific data to understand the effect of restoration works."),
             h2("When was the data last updates?"),
             p("Last update - 06 October 2021
               
               Next planned update - TBC"),
             h2("Contact us"),
             p("If you spot anything that doesn't look right or have any queries please contact 
               the Peatland ACTION Data and Evidence Team peatlandactiondata@nature.scot."),
             h2("More information and datasets"),
             p("Visit Peatland ACTION for more information on our programme of restoration, 
               and our open data page for more datasets collected as part of this programme.
               Visit Scotland's Soils for more information, maps and data on Scotland's peatlands.")
             
    ),
    
    # Data tab
    tabPanel("Data",
             leafletOutput("map"),
             
             selectInput('locality_input',
                         'Choose a site:',
                         choices = unique(vegetation_surveys$locality)), 
             
             selectInput('dataset_input',
                         'Select dataset:',
                         choices = unique(vegetation_surveys$dataset_name)),
             
             actionButton(inputId = 'update', 
                          label = 'Update dashboard?'),
             
             DT::dataTableOutput('table_output')
    ),
    
    # Accessibility tab
    tabPanel("Accessibility",
             p("We want the Peatland Action - Vegetation Survey Results to be accessible and usable for as many people as possible."),
             h2("Feedback"),
             p("If you cannot access any part of this site or want to report an accessibility problem, please email peatlandactiondata@nature.scot"),
             h2("Enforcement procedure"),
             p("The Equality and Human Rights Commission enforces the accessibility regulations (the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018).
               If you're not happy with how we respond to your feedback contact the Equality Advisory and Support Service . They are an independent advice service. They will advise you on what to do next."),
             h2("Compliance statement"),
             p("NatureScot commits to making its websites accessible in line with the accessibility regulations. This accessibility statement applies to the Peatland Action - Vegetation Survey Results explorer
               This statement was prepared on 7 Jan 2021 and last reviewed on 7 Jan 2021")
          
    )
  )
)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    vegetation_surveys %>%
      filter(locality == input$locality_input) %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        clusterOptions = markerClusterOptions(),
        popup = ~paste("Scientific Name:", scientific_name)
      )
  })
  
  filtered_data <- eventReactive(eventExpr = input$update,
                                 valueExpr = {
                                   vegetation_surveys %>%
                                     filter(locality == input$locality_input,
                                            dataset_name == input$dataset_input) %>%
                                     select(scientific_name, vitality, life_stage,
                                            organism_quantity, grid_reference,
                                            event_date, recorded_by)
                                 })
  
  output$table_output <- renderDataTable({
    datatable(filtered_data(),
              colnames = c("Scientific Name" = "scientific_name", "Event Date" = "event_date"))
  })
}

shinyApp(ui = ui, server = server)
