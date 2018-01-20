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
  
    subset(
      wine,
      country %in% input$countryInput &
        price >= input$priceInput[1] & price <= input$priceInput[2] &
        points >= input$scoreInput[1] & points <= input$scoreInput[2] 
        
    )
  })
  
 
  
  output$wineResults <- renderDataTable({
    filtered_wine() %>% select(country,price,points,title,variety)
  })  
  
  

  
  
})
