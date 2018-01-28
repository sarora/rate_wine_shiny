suppressMessages({
  library(shiny)
  library(tidyverse)
  library(DT)
  library(RColorBrewer)
  library(shinycssloaders)
  library(plotly)
})

### reading in the cleaned file
suppressWarnings(suppressMessages(wine <- readr::read_csv("data/wine_fil.csv")))

### mutating price as a numeric
suppressWarnings({wine <- wine %>% 
  mutate(price = as.numeric(price))})

## Renaming variables
wine <- rename(wine, 
                   Country = country,Description = description, Designation = designation, Price = price, Province= province, Region = region_1,
                   Name = title, Variety = variety, Winery = winery, Ratings=points)

