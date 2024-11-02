#import libraries
library(tidyverse)
library(dplyr)
library(sf)
library(ggplot2)

setwd("~/GitHub/campaign_trails_cdj/campaign_csvs")
all_visits <- read_csv('all_visits.csv')

setwd("~/GitHub/campaign_trails_cdj/")
cities <- read_csv('us-cities-top-1k.csv')
cities <- cities |> 
  mutate(location = paste0(City,", ",State)) |> 
  select(location, Population)

all_visits_location <- all_visits |> 
  left_join(cities, join_by(location == location)) |> 
  group_by(location) |> 
  summarize(count=n(), lng=first(lng),lat=first(lat))

all_visits_location <- all_visits_location |> 
  filter(!is.na(lng) | !is.na(lat)) |> 
  st_as_sf(coords=c("lng","lat")) |> 
  st_set_crs(4326)

#points <- all_visits_location |> 
#  st_coordinates() |> 
#  as.data.frame()

usa <- st_as_sf(maps::map("state", fill=TRUE, plot=FALSE))

ggplot()+
  geom_sf(data=usa, color = "#444444", fill = "#FFF8eb", linewidth=.75)+
  #stat_density_2d(data=points, aes(x=X, y=Y, fill = ..level..), geom = "polygon")+
  geom_sf(data=all_visits_location, aes(size=count),color='#90EE90', alpha=0.8)+
  theme_void()+
  labs(title="All Campaign Visits From 2004 Onwards<br>",
       caption="<br><br>Nikhil Chinchalkar for Cornell Data Journal | 2024 ", 
       size="Visits")+
  theme(plot.title = ggtext::element_markdown(size = 22, hjust =0.5, face = "bold", color="#444444"), 
        plot.subtitle = ggtext::element_markdown(size = 16, hjust =0.5, face = "bold", color="#444444"), 
        plot.caption = ggtext::element_markdown(size = 8, hjust =0.5, color="#444444"),
        legend.position = "bottom",
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 12),
        plot.background = element_rect(fill = "#FFF8EB"))

all_visits_state <- all_visits |> 
  left_join(cities, join_by(location == location)) |> 
  group_by(state) |> 
  summarize(count=n(), lng=first(lng),lat=first(lat)) |> 
  mutate(state = tolower(state))

visit_state_plot <- inner_join(usa, all_visits_state, join_by(ID == state))

plot <- ggplot(visit_state_plot)+
  geom_sf(data=usa, color="#fff8eb", linewidth=1)+
  geom_sf(aes(fill=count),color="#444444", linewidth=1)+
  scale_fill_gradient2(mid="#fff8eb", high = "#90ee90",
                       guide = guide_colorbar(barwidth = 10, barheight = 0.5,frame.colour = "black"))+
  theme_minimal()+
  theme_void()+
  labs(title="All Campaign Visits From 2004 Onwards<br>", 
       fill="Visits")+
  theme(plot.title = ggtext::element_markdown(size = 22, hjust =0.5, face = "bold", color="#444444"), 
        plot.subtitle = ggtext::element_markdown(size = 16, hjust =0.5, face = "bold", color="#444444"), 
        plot.caption = ggtext::element_markdown(size = 8, hjust =0.5, color="#444444"),
        legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        plot.background = element_rect(fill = "#FFF8EB", color="#FFF8EB"),
        plot.margin = margin(10, 10, 10, 10))

ggsave("heatmap.svg", plot = plot, width = 10, height = 8, device = "svg")

