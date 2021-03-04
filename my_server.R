# Data input
owid_co2_data <- read.csv("data/owid-co2-data.csv", na.strings = c("", NA)) 


# Data Wrangling

owid_co2_data <- owid_co2_data %>%
  filter(country != "World", !is.na(iso_code))

world_shapes <- map_data("world") %>% filter(region != "Antarctica")

world_shapes[world_shapes$region == "UK", "region"] <- "United Kingdom"
world_shapes[world_shapes$region == "USA", "region"] <- "United States"
world_shapes[world_shapes$region == "Democratic Republic of the Congo", 
             "region"] <- "Democratic Republic of Congo"
world_shapes[world_shapes$region == "Republic of Congo", "region"] <- "Congo"
world_shapes[world_shapes$region == "Czech Republic", "region"] <- "Czechia"
world_shapes[world_shapes$region == "Timor-Leste", "region"] <- "Timor"
world_shapes[world_shapes$region == "Macedonia", "region"] <- "North Macedonia"


# Server
my_server <- function(input, output) {
  
  output$table <- renderTable({
    owid_co2_data <- owid_co2_data %>%
      filter(country != "World", !is.na(iso_code))
    
    if(input$table_data_type == "Top CO2 emissions") {
      top_co2_emission <- owid_co2_data %>%
        filter(year == input$table_year) %>%
        select(country, co2, co2_growth_abs, co2_growth_prct)
      
      table_result <- slice_max(top_co2_emission, co2, n= input$n)
      
      colnames(table_result) <- c("Country", "CO2 emission",
                                  "CO2 growth by year",
                                  "Percent CO2 growth by year")
      
    } else if (input$table_data_type == "Top Year-on-year increase in CO2 emissions"){
      top_co2_increase <- owid_co2_data %>%
        filter(year == input$table_year) %>%
        select(country, co2, co2_growth_abs, co2_growth_prct)
      
      table_result <- slice_max(top_co2_increase, co2_growth_abs, n= input$n)
      
      colnames(table_result) <- c("Country", "CO2 emission",
                                  "CO2 growth by year",
                                  "Percent CO2 growth by year")
    } else {
      top_co2_decrease <- owid_co2_data %>%
        filter(year == input$table_year) %>%
        select(country, co2, co2_growth_abs, co2_growth_prct)
      
      table_result <- slice_min(top_co2_decrease, co2_growth_abs, n= input$n)
      
      colnames(table_result) <- c("Country", "CO2 emission",
                                  "CO2 growth by year",
                                  "Percent CO2 growth by year")
    }
    return(table_result)
    
  })
  
  output$table_title <- renderText({
    if(input$table_data_type == "Top CO2 emissions") {
      return(paste("Top", input$n, 
                   "Countries with the most CO2 emissions in", 
                   input$table_year, sep = " "))
    } else if (input$table_data_type == "Top Year-on-year increase in CO2 emissions"){
      return(paste("Top", input$n, 
                   "Countries with the most increase in CO2 emissions in", 
                   input$table_year, sep = " "))
    } else {
      return(paste("Top", input$n, 
                   "Countries with the most decrease in CO2 emissions in", 
                   input$table_year, sep = " "))
    }
  })
  
  
  output$world <- renderPlot({
    world_co2_data <- owid_co2_data %>%
      filter(year == input$plot_year) %>%
      select(country, co2, co2_growth_abs) %>%
      right_join(world_shapes, by = c("country" = "region"))
    
    if(input$plot_data_type == "CO2 emissions") {
      data_choice <- "co2"
      title_choice <- paste("CO2 emissions in ", input$plot_year)
      color_choice <- "CO2 emissions \n (million tonnes per year)"
    } else {
      data_choice <- "co2_growth_abs"
      title_choice <- paste("Year-on-year change in CO2 emissions in ", input$plot_year)
      color_choice <- "Change in CO2 emisisons \n(million tonnes per year)"
      
    }
    
    world_co2_plot <- world_co2_data %>%
      ggplot() +
      geom_polygon(aes_string(x = "long", y = "lat", group = "group", fill = data_choice)) +
      scale_fill_distiller(palette = "YlOrRd", direction = 1) +
      coord_quickmap() +
      labs(
        title = title_choice,
        fill = color_choice
      )
    
    return(world_co2_plot)
  })
  
  output$map_title <- renderText({
    if(input$plot_data_type == "CO2 emissions") {
      return(paste("CO2 emissions in ", input$plot_year))
    }else{
      return(paste("Year-on-year change in CO2 emissions in ", input$plot_year))
    }
  })
  
}