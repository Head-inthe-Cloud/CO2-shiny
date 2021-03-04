library(tidyverse)
library(dplyr)
library(ggplot2)
library("maps")

world_shapes <- map_data("world") %>% filter(region != "Antarctica")

world_shapes[world_shapes$region == "UK", "region"] <- "United Kingdom"
world_shapes[world_shapes$region == "USA", "region"] <- "United States"
world_shapes[world_shapes$region == "Democratic Republic of the Congo", 
             "region"] <- "Congo"

world_co2_data <- owid_co2_data %>%
  filter(year == 1950) %>%
  select(country, co2) %>%
  right_join(world_shapes, by = c("country" = "region"))

world_co2_plot <- ggplot(data = world_co2_data) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = co2)) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1)
  coord_quickmap()

  
