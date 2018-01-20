#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#




# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  
  
  output$countryOutput <- renderUI({
    wine <- wine 
    selectInput(
      "countryInput",
      h5(paste0("Select Country: (can select multiple)")),
      sort(unique(wine$country)),
      multiple = TRUE
    )
  })
  
  
  output$priceOutput <- renderUI({
      sliderInput(
        "priceInput",
        h5("Price of Wine:"),
        value = c(0,60),
        min = 0,
        max = 3500,
        sep = "",
        step = 200
      )
    })
  
  output$scoreOutput <- renderUI({
    sliderInput(
      "scoreInput",
      h5("Score:"),
      value = c(80,81),
      min = 80,
      max = 100,
      sep = "",
      step = 2
    )
  })
  
  
  filtered_wine <- reactive({
     
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    
    
    subset(
      wine,
      country %in% input$countryInput &
        price >= input$priceInput[1] & price <= input$priceInput[2] &
        points >= input$scoreInput[1] & points <= input$scoreInput[2] 
        
    )
  })
  
 
    
  
    output$wineResults <- renderDataTable({
  
      if (!is.null(input$countryInput) & length(input$countryInput>0)) {
        filtered_wine() %>% select(country,price,points,title,variety)
      }  
    
    })  
  
    
    output$summaryText <- renderText({
      numRows <- nrow(filtered_wine())
      if (is.null(numRows)) {
        numRows <- 0
      }
      paste0(numRows, " results found.")
    
      
      
    })
    
    
    
  output$graphProvResults <- renderPlotly({

  
    if (is.null( filtered_wine())) {
      return(NULL)
    }
  
    plot <- ggplot(filtered_wine(), aes(Name=title)) + 
        geom_point(aes(price, points, colour=country)) +
        labs(x="Price (USD)", y="Wine Rating", title="Comparing Wine Quality and Price per Country") +
          theme_minimal() +
            theme( plot.title = element_text(hjust = 0.5, size=20), axis.title.x = element_text(size=15),axis.title.y = element_text(size=15))

     ggplotly(plot) %>% 
       config(displayModeBar = FALSE)
    

  })
  

  

  
  
})
