#import libraries
library(tidyverse)
library(dplyr)
library(ggplot2)

setwd("~/GitHub/campaign_trails_cdj/campaign_csvs")
all_visits <- read_csv('all_visits.csv')

setwd("~/GitHub/campaign_trails_cdj/")
cities <- read_csv('us-cities-top-1k.csv')
cities <- cities |> 
  mutate(Location = paste0(City,", ",State)) |> 
  select(Location, Population) |> 
  group_by(Location) |> 
  summarize(
    Population = first(Population)
  )

all_visits_location <- all_visits |> 
  left_join(cities, join_by(location == Location)) |> 
  group_by(location, candidate, year) |> 
  filter(!is.na(Population)) |> 
  summarise(
    visits=n(),
    population=first(Population),
    candidate_party=first(candidate_party),
    people_visited = population * (2 - 1 / (2 ^ (visits - 1)))
  )

write_csv(all_visits_location, 'test2.csv')

party_location_visits <- all_visits_location |> 
  group_by(candidate_party, year) |> 
  summarize(
    candidate=first(candidate),
    average = median(population)
  )

ggplot(party_location_visits, aes(x=factor(year), y=average, fill=candidate_party)) +
  geom_bar(stat="identity", position="dodge")+
  labs(x="Year", y="Population (Average)", title="Population by Election Year and Party") +
  scale_fill_manual(values=c("Democrat"="blue", "Republican"="red")) +
  theme_minimal()
