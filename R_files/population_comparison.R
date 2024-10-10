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
  group_by(location, candidate_party) |> 
  summarize(count=n(), lng=first(lng),lat=first(lat), population=first(Population))

ggplot()+
  geom_point(data=all_visits_location, aes(x=population, y=count, color=candidate_party))+
  scale_x_continuous(trans='log10')
