
# Pages


page_one <- tabPanel(
  title="Tables",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "table_data_type", label = "Data Type",
                  choices = c("Top CO2 emissions", 
                              "Top Year-on-year increase in CO2 emissions",
                              "Top Year-on-year decrease in Co2 emissions"),
                  selected = "Top CO2 emissions"),
      
      sliderInput(inputId = "table_year", label = "Year", min = 1800, max = 2019, value = 2019),
      numericInput(inputId = "n", label = "Number of Countries presented in Table", value = 10)
    ),
    
    mainPanel(
      titlePanel(
        textOutput(outputId = "table_title")),
      tableOutput(outputId = "table")
      
      
    )
  )
)


page_two <- tabPanel(
  title="Maps",    
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "plot_data_type", label = "Data Type",
                  choices = c("CO2 emissions", "Year-on-year change in CO2 emissions"),
                  selected = "CO2 emissions"),
      
      sliderInput(inputId = "plot_year", label = "Year", min = 1800, max = 2019, value = 2019)    ),
    
    mainPanel(
      titlePanel(
        textOutput(outputId = "map_title")
      ),
      plotOutput(outputId = "world")
      
    )
  )
)



# UI
my_ui <- navbarPage(
  "World CO2 Emissions",
  page_one,
  page_two
)