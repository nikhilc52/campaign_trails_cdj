#import libraries
library(tidyverse)
library(dplyr)
library(tidygeocoder)


#read in dataset
data <- read_csv('[raw] bush_2004.csv')

data$date <- as_date(data$date, format="%m/%d/%Y")

data <- data |> 
  mutate(lat = geo_osm(location)$lat) |> 
  mutate(lng = geo_osm(location)$long)

write_csv(data, 'bush_2004.csv')

data <- read_csv('[raw] kerry_2004.csv')

data$date <- as_date(data$date, format="%m/%d/%Y")

data <- data |> 
  mutate(lat = geo_osm(location)$lat) |> 
  mutate(lng = geo_osm(location)$long)

write_csv(data, 'kerry_2004.csv')
