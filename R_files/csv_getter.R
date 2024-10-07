#import libraries
library(tidyverse)
library(dplyr)
library(tidygeocoder)

candidate <- "Trump"
year <- 2020

#read in dataset
data <- readxl::read_xlsx('2008-2020_database.xlsx')

#filter based on candidate and year
#only include unique visits for the candidate
candidate_year <- data |> 
  filter(Candidate == candidate) |> 
  filter(Year == year) |> 
  distinct(Candidate, Year, Date, State, City) |> 
  mutate(date = paste0(Date, ".",Year))

candidate_year$date <- as.Date(candidate_year$date, format="%m.%d.%Y")

candidate_year <- candidate_year |> 
  mutate(location = paste0(City, ", ",State)) |> 
  select(date, location, City, State) |> 
  rename('city' = 'City') |> 
  rename('state' = 'State') |> 
  mutate(lat = geo_osm(location)$lat) |> 
  mutate(lng = geo_osm(location)$long)

write_csv(candidate_year, paste0(tolower(candidate),"_",year,".csv"))

