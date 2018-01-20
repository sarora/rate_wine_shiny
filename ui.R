#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram

shinyUI(fluidPage(
  
  theme = "style\bootstrap.css",
  # Application title
  titlePanel("Wine Selector"),
  em("by Liquor Mogul"),
  br(),
  br(),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("countryOutput"),
      hr(),
      uiOutput("priceOutput"),
      hr(),
      uiOutput("scoreOutput"),
      hr()
 
    ),
    
    #Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("wineResults")
    )
  )
))








