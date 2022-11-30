# A5
# Load ui and server variables
source("app_ui.R")
source("app_server.R")

library(tidyverse)
library(shiny)

# Run application using the loaded `ui` and `server` variables
shinyApp(ui = ui, server = server)
