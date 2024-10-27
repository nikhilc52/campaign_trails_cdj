#import libraries
library(tidyverse)
library(dplyr)
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
  replace_na(list(Population=25000)) |>  
  group_by(location, candidate_party, year) |> 
  summarize(count=n(), lng=first(lng),lat=first(lat), population=first(Population),
            candidate=first(candidate))

party_location_visits <- all_visits_location |> 
  filter(population > 25000) |> 
  group_by(candidate_party, year) |> 
  summarize(
    candidate=first(candidate),
    average = mean(population)
  )

ggplot(party_location_visits, aes(x=factor(year), y=average, fill=candidate_party)) +
  geom_bar(stat="identity", position="dodge")+
  labs(x="Year", y="Population (Average)", title="Population by Election Year and Party") +
  scale_fill_manual(values=c("Democrat"="blue", "Republican"="red")) +
  theme_minimal()
