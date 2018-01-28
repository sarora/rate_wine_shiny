suppressMessages({
  library(shiny)
  library(tidyverse)
  library(DT)
  library(RColorBrewer)
  library(shinycssloaders)
  library(plotly)
})

suppressWarnings(suppressMessages(wine <- readr::read_csv("data/wine_fil.csv")))

suppressWarnings({wine <- wine %>% 
  mutate(price = as.numeric(price))})
