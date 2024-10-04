#import libraries
library(tidyverse)
library(dplyr)
library(gganimate)
library(ggplot2)
library(sf)

##################
#read in a candidate file
democrat <- read_csv('clinton.csv')

#format the date column
democrat$date <- as_date(democrat$date, format="%m/%d/%Y")

#add a party column for grouping
democrat <- democrat |> 
  mutate(party = "Democrat")

#group data by date and count the index of a date duplicate
#count the number of duplicates for each date
democrat <- democrat |> 
  group_by(date) |> 
  mutate(date_duplicate_count = row_number()) |> 
  mutate(date_count = n())

#format the date_time column to include time
#space out multiple visits on the same date by time, using the data defined above
democrat <- democrat |> 
  mutate(date_time = as.POSIXct(date, format = "%m/%d/%Y")) |> 
  mutate(date_time = date_time + date_duplicate_count*(24/(date_count+1))*60*60)

#set CRS for plotting
democrat <- democrat |> 
  st_as_sf(coords=c("lng","lat")) |> 
  st_set_crs(4326)

#get the map of the US
usa <- st_as_sf(maps::map("state", fill=TRUE, plot=FALSE))

##################
republican <- read_csv('trump.csv')

republican$date <- as_date(republican$date, format="%m/%d/%Y")

republican <- republican |> 
  mutate(party = "Republican")

republican <- republican |> 
  group_by(date) |> 
  mutate(date_duplicate_count = row_number()) |> 
  mutate(date_count = n())

republican <- republican |> 
  mutate(date_time = as.POSIXct(date, format = "%m/%d/%Y")) |> 
  mutate(date_time = date_time + date_duplicate_count*(24/(date_count+1))*60*60)

republican <- republican |> 
  st_as_sf(coords=c("lng","lat")) |> 
  st_set_crs(4326)

#shift the republican map to the right to show both at the same time on the same plot
republican <- lwgeom::st_wrap_x(republican, wrap=0, move=70)
usa_shifted <- lwgeom::st_wrap_x(usa, wrap=0, move=70)

####################
#plotting
#plot each USA, the background colors for each candidate, and the current colors for each candidate
#annotate the candidate names
#add theme, title, and labels (formatting date)
#transition with date_time
#mark the shadow for each visit so it stays visible after
#ease transitions between visits for smoothness
animation <- ggplot() +
  geom_sf(data=usa_shifted, color = "#ebebeb", fill = "gray", linewidth=.75)+
  geom_sf(data=usa, color = "#ebebeb", fill = "gray", linewidth=.75)+
  geom_sf(data=republican, color="white", fill="red",shape=21, size=3, aes(group = party), stroke=1)+
  geom_sf(data=democrat, color="white", fill="blue", shape=21, size=3, aes(group = party), stroke=1)+
  geom_sf(data=republican, color="black", fill="green",shape=21, size=3, aes(group = party), stroke=1)+
  geom_sf(data=democrat, color="black", fill="green",shape=21, size=3, aes(group = party), stroke=1)+
  annotate("text", label="Clinton",x=-100, y=23)+
  annotate("text", label="Trump",x=-27, y=23)+
  theme_void()+
  labs(title="2016 Presidental Campaign Trail", 
       subtitle="{format(frame_time, \"%h. %d\")}",
       caption="<br><br>Nikhil Chinchalkar for Cornell Data Journal | FiveThirtyEight | 2024 ")+
  theme(plot.title = ggtext::element_markdown(size = 22, hjust =0.5, face = "bold"), 
        plot.subtitle = ggtext::element_markdown(size = 16, hjust =0.5, face = "bold"), 
        plot.caption = ggtext::element_markdown(size = 8, hjust =0.5))+
  transition_time(date_time)+
  shadow_mark(color="white", shape=21, exclude_layer = c(5,6))+
  ease_aes("cubic-in-out")

#about 67 days from Sep 1 to ~Nov 6, so use that as a baseline for frames
#30 second long GIF
#30 frames of pause is about 4-5 seconds
animate(animation, nframes=67*5, height = 4, duration = 30, end_pause = 30,
        width = 9, units = "in", res = 200)

#testing animation, much quicker to render
#animate(animation, fps=3, duration=20, height = 4,
#        width = 9, units = "in", res = 200)
