#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




# Define server logic 
## dropdown for countries
shinyServer(function(input, output) {
  output$countryOutput <- renderUI({
    wine <- wine
    selectInput(
      "countryInput",
      h5("Select Country: (can select multiple)"),
      sort(unique(wine$country)),
      multiple = TRUE,
      selected = c("New Zealand","Australia")
      
    )
  })
  
  ## slider Input
  
  output$priceOutput <- renderUI({
    sliderInput(
      "priceInput",
      h5("Price of Wine:"),
      value = c(0, 60),
      min = 0,
      max = 3300,
      pre = '$',
      sep = "",
      step = 200
    )
  })
  
  output$scoreOutput <- renderUI({
    sliderInput(
      "scoreInput",
      h5("Points:"),
      value = c(80, 85),
      min = min(wine$points),
      max = max(wine$points),
      sep = "",
      step = 2
    )
  })
  
  
  
  ## radio Button for 
  output$grapeType <- renderUI({
    radioButtons(
      "grapeVariety",
      h5("Select Grape Type:"),
      c(
        "Red" = "Red",
        "White" = "White",
        "Both" = "Both"
      )
    )
  })
  
  
  
  filterGrape <- function() {
    if (input$grapeVariety == "Both") {
      unique(wine$Grape)
    } else{
      input$grapeVariety
    }
    
  }
  
  observe({
    print(filterGrape)
  })
  
  
  filtered_wine <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    
 arrange(subset(
      wine,
      country %in% input$countryInput &
        price >= input$priceInput[1] &
        price <= input$priceInput[2] &
        points >= input$scoreInput[1] &
        points <= input$scoreInput[2] &
        Grape %in% filterGrape()
    ),desc(points))
  
    
})
  
  
  
  output$wineResults = DT::renderDataTable({
    
    if (!is.null(input$countryInput) & length(input$countryInput > 0)) {
      filtered_wine() %>% select(country, price, points, title, variety, Grape)
    }
},
  # table options
  extensions = 'Buttons', 
  options = list(
    scrollX = TRUE,
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel', 'pdf')
  )
)

  
  
  

  output$summaryText <- renderText({
    numRows <- nrow(filtered_wine())
    if (is.null(numRows)) {
      numRows <- 0
      
      paste0(numRows, " results found. Please add countries to see results")
    
    }
    else{
      paste0(numRows, " results found")
    }
    
  })
  
  
  
  
   output$download <- downloadHandler(
     filename = function() {
       paste("filtered_wine", ".pdf", sep = "")
     },
     content = function(con) {
       file.copy(filtered_wine, con)
  }
   )

  
 
  output$graphProvResults <- renderPlotly({
    if (is.null(filtered_wine())) {
      return(NULL)
    }
    
    plot <- ggplot(filtered_wine(), aes(Name = title)) +
      geom_point(aes(price, points, colour = country)) +
      labs(x = "Price (USD)", y = "Wine Rating", title = "Comparing Wine Quality and Price per Country") +
        scale_x_continuous(labels = scales::dollar_format()) +
          theme_minimal() +
            theme(
             plot.title = element_text(hjust = 0.5, size = 15),
               axis.title.x = element_text(size = 15),
                axis.title.y = element_text(size = 15))
    
    
    ggplotly(plot) %>%
      config(displayModeBar = FALSE)
    
    
  })
  
  
  
  
  
  
})
