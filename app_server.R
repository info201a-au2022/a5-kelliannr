# Server code

library(shiny)
library(ggplot2)
library(plotly)
co2_data <- read_csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

# Define server logic required
server <- function(input, output) {
  output$population_co2 <- renderPlotly({
    population_co2_data <- co2_data %>%
                           filter(country == "United States") %>% 
                           select(year, population, co2) %>% 
                           filter(!is.na(population) & !is.na(co2) & !is.na(year))
    
    plot_population_co2 <- population_co2_data %>% 
                           ggplot(aes(x = population, y = co2, color = year)) + 
                           geom_point() +
                           labs(x = "Population",
                                y = "CO2 Emission",
                                title = "CO2 vs Population in the United States"
                                ) +
                           scale_x_continuous(labels = scales::comma) +
                           scale_y_continuous(labels = scales::comma)
    
    ggplotly(plot_population_co2)
  })
  
  output$pop_cor2 <- renderText({
    population_co2 <- co2_data %>%
      filter(country == "United States") %>%
      select(year, population, co2) %>%
      filter(!is.na(population) & !is.na(co2) & !is.na(year))
    
    cor_eff <- cor(population_co2$population, population_co2$co2, use = "complete.obs")
    total <- paste0("In the graph above, we can see that there is a pretty strong relationship between
                     CO2 emission and population. This makes sense because the correlation coefficient
                     betweenthe two variables is ",
                    round(cor_eff, digits = 2),
                    ", indicating a strong positive correlation."
                   )
    return(total)
  })
  
  output$methane <- renderPlotly({
    methane_emisson <- co2_data %>%
                       filter(country == "United States") %>% 
                       select(year, methane) %>%
                       filter(!is.na(year) & !is.na(methane)) %>%
                       group_by(year) %>%
                       summarize(avg_methane_emission = mean(methane, na.rm = T))
    
    plot_methane_emission <- methane_emisson %>% 
                             ggplot(aes(x = year, y = avg_methane_emission)) +
                             geom_col() +
                             labs(x = "Year",
                                  y = "Average Methane Emission",
                                  title = "Average Methane Emission vs Year in the United States"
                                  )
    
    ggplotly(plot_methane_emission)
  })
  
  output$meth_emit <- renderText({
    methane_emisson <- co2_data %>%
                       filter(country == "United States") %>% 
                       select(year, methane) %>%
                       filter(!is.na(year) & !is.na(methane)) %>%
                       group_by(year) %>%
                       summarize(avg_methane_emission = mean(methane, na.rm = T))
    
    high_methane_year <- methane_emisson %>% 
                         filter(avg_methane_emission == max(avg_methane_emission, na.rm = T)) %>%
                         pull(year)
    
    low_methane_year <- methane_emisson %>%
                        filter(avg_methane_emission == min(avg_methane_emission, na.rm = T)) %>%
                        pull(year)
    
    total <- paste0("The graph above allows us to compare the average methane emission of different
                     years with each other. We are able to deduct that the year with the highest
                     methane emission was ",
                    high_methane_year,
                    " and the lowest methane emission was in ",
                    low_methane_year,
                    "."
                    )
    return(total)
  })
  
  output$co2gdp <- renderPlotly({
    co2_gdp <- co2_data %>% 
               filter(country == "United States") %>% 
               select(year, gdp, co2_per_gdp) %>% 
               filter(!is.na(year) & !is.na(gdp) & !is.na(co2_per_gdp))
    
    plot_co2_gdp <- co2_gdp %>% 
                    ggplot(aes(x = gdp, y = co2_per_gdp, color = year)) +
                    geom_point() +
                    labs(x = "GDP (gross domestic product)",
                         y = "CO2 per GDP",
                         title = "Carbon Dioxide Emission per GDP vs GDP in the United States"
                         ) +
                    scale_x_continuous(labels = scales::comma)
    
    ggplotly(plot_co2_gdp)
  })
  
  output$co2gdp_eff <- renderText({
    co2_gdp <- co2_data %>% 
               filter(country == "United States") %>% 
               select(year, gdp, co2_per_gdp) %>% 
               filter(!is.na(year) & !is.na(gdp) & !is.na(co2_per_gdp))
   
    cor_eff <- cor(co2_gdp$gdp, co2_gdp$co2_per_gdp, use = "complete.obs")
    
    total <- paste0("In the graph above, we can see that there's an inital steep correlation between
                     CO2 per GDP and GDP, then it starts to taper off into a negative correlation. 
                     This overall correlation is reflective in the corresponding correlation 
                     coefficient, ",
                    round(cor_eff, digits = 2),
                    ", seeing as the trend is overall negative but also doesn't have a distinctive
                    continuous correlation when looking at the overall correlation."
                    )
    return(total)
  })
  
  output$user_plot <- renderPlotly({
    plot <- co2_data %>%
            filter(country == input$country) %>% 
            select(year, input$x_input, input$y_input) %>% 
            filter(!is.na(year) & !is.na(input$x_input) & !is.na(input$y_input)) %>% 
            ggplot(mapping = aes_string(x = input$x_input, y = input$y_input)) +
            geom_point(aes(color = year)) +
            labs(x = input$x_input,
                 y = input$y_input,
                 title = paste(input$y_input, "vs", input$x_input, "in", input$country)
                 ) +
            scale_x_continuous(labels = scales::comma) +
            scale_y_continuous(labels = scales::comma)
    
    if (input$trendline) {
      plot <- plot + geom_smooth(se = F, color= "red")
    }
    ggplotly(plot)
  })
}