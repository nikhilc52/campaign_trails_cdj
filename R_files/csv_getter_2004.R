#import libraries
library(tidyverse)
library(dplyr)
library(tidygeocoder)


#read in dataset
data <- read_csv('[raw] harris_2024.csv')

data$date <- as_date(data$date, format="%m/%d/%Y")

data <- data |> 
  mutate(lat = geo_osm(location)$lat) |> 
  mutate(lng = geo_osm(location)$long)

write_csv(data, 'harris_2024.csv')

data <- read_csv('[raw] trump_2024.csv')

data$date <- as_date(data$date, format="%m/%d/%Y")

data <- data |> 
  mutate(lat = geo_osm(location)$lat) |> 
  mutate(lng = geo_osm(location)$long)

write_csv(data, 'trump_2024.csv')
