# UI code

library(shiny)
library(ggplot2)
library(plotly)
co2_data <- read_csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

intro_panel <- tabPanel(
  "Introduction",
  h2("Introduction"),
  
  p("The amount of harmful gases we humans emit from our creations is astounding. And the number can only
     increase as our total population grows. The numbers and patterns reveal themselves when the data
     is looked at and compared. In this report, I will compare the following three pairs of variables:"
  ),
  
  tags$ul(
    tags$li("CO2 emission and population"),
    tags$li("year and methane emission"),
    tags$li("GDP and CO2 per GDP")
  ),
  
  p("Using the the data for each of the variable pairs, we can answer the following questions:"),
  
  tags$ul(
    tags$li("What is the relationship between population and CO2 emissions in the US?"),
    tags$li("What year is the average methane emission in the US the highest? The lowest?"),
    tags$li("How does the CO2 emission per GDP change with the overall GDP in the US?")
  ),
  
  p("Specifics and answers to the above questions are detailed in the rest of the page. For further
     personal exploration, please navigate to the 'Exploration' tab which can be accessed at the top
     of this page"
  ),
  
  h3("What is the relationship between population and CO2 emissions in the US?"),
  plotlyOutput("population_co2"),
  p(textOutput("pop_cor2")),
  
  h3("What year was the average methane emission in the US the highest? The lowest?"),
  plotlyOutput("methane"),
  p(textOutput("meth_emit")),
  
  h3("How does the CO2 emission per gdp change with the overall GDP in the US?"),
  plotlyOutput("co2gdp"),
  p(textOutput("co2gdp_eff"))
)

inputs <- sidebarPanel(
  selectInput(
    "x_input",
    "Select an x variable:",
    choices = colnames(co2_data)[-c(1, 2, 3)],
    selected = "population"
  ),
  selectInput(
    "y_input",
    "Select a y variable:",
    choices = colnames(co2_data)[-c(1, 2, 3)],
    selected = "gdp"
  ),
  selectInput(
    "country",
    "Select a country:",
    choices = unique(co2_data$country),
    selected = "Afghanistan"
  ),
  checkboxInput(
    "trendline",
    "Include trendline?",
    value = F
  )
)

explore_panel <- tabPanel(
  "Exploration",
  sidebarLayout(
    inputs,
    mainPanel(plotlyOutput("user_plot"),
              "Disclaimer: If certain values are selected and an error shows up, it means
                            that there is no data available for whatever value was picked."
              )
  ),
  h3("Reasoning For the Chart"),
  p("The above chart allows the user to conduct their own data analysis because what I covered on
     the introduction page is only three analyses out of many. The users may be interested in 
     different things than I am and allowing them to change what is graphed can account for that
     variable interest."),
  
  h3("Patterns Revealed"),
  p("Through graphing different variables for different countries, it is easily revealed that not
     all combinations of data for certain countries produce a graph. When the trendline box is
     checked, it is also easy to see that it does not span the whole width of the graph. Both of
     these things are influenced by the fact that there is quite a lot of missing data in the original
     dataset so it makes sense that a degree of incompleteness is present.")
)

# Define UI for application
ui <- navbarPage("CO2 Emission Data Exploration", intro_panel, explore_panel)
