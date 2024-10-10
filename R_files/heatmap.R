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
  geom_sf(data=usa, color = "#ebebeb", fill = "gray", linewidth=.75)+
  #stat_density_2d(data=points, aes(x=X, y=Y, fill = ..level..), geom = "polygon")+
  geom_sf(data=all_visits_location, aes(size=count),color='orange', alpha=0.5)+
  theme_void()+
  labs(title="All Campaign Visits From 2004 Onwards<br>",
       caption="<br><br>Nikhil Chinchalkar for Cornell Data Journal | 2024 ", 
       size="Visits")+
  theme(plot.title = ggtext::element_markdown(size = 22, hjust =0.5, face = "bold"), 
        plot.subtitle = ggtext::element_markdown(size = 16, hjust =0.5, face = "bold"), 
        plot.caption = ggtext::element_markdown(size = 8, hjust =0.5),
        legend.position = "bottom",
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 12))

all_visits_state <- all_visits |> 
  left_join(cities, join_by(location == location)) |> 
  group_by(state) |> 
  summarize(count=n(), lng=first(lng),lat=first(lat)) |> 
  mutate(state = tolower(state))

visit_state_plot <- inner_join(usa, all_visits_state, join_by(ID == state))

ggplot(visit_state_plot)+
  geom_sf(data=usa, fill = "#ebebeb", linewidth=.75)+
  geom_sf(aes(fill=count))+
  scale_fill_gradient2(low = "#ebebeb", high = "darkblue", 
                       guide = guide_colorbar(barwidth = 10, barheight = 0.5))+
  theme_minimal()+
  theme_void()+
  labs(title="All Campaign Visits From 2004 Onwards<br>",
       caption="<br><br>Nikhil Chinchalkar for Cornell Data Journal | 2024 ", 
       fill="Visits")+
  theme(plot.title = ggtext::element_markdown(size = 22, hjust =0.5, face = "bold"), 
        plot.subtitle = ggtext::element_markdown(size = 16, hjust =0.5, face = "bold"), 
        plot.caption = ggtext::element_markdown(size = 8, hjust =0.5),
        legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))
