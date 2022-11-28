# A5
library("shiny")

# Load ui and server variables
source("app_ui.R")
source("app_server.R")

# Run application using the loaded `ui` and `server` variables
shinyApp(ui = ui, server = server)
