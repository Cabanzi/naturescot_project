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