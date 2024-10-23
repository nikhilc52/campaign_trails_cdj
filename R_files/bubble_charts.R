library(tidyverse)
library(dplyr)
library(ggplot2)

all_visits <- read.csv("all_visits.csv") %>% 
  filter(candidate_party == "Democrat")

working <- all_visits %>% 
  group_by(location, candidate_party) %>%  
         summarize(
           count=n()) %>% 
  filter(count > 4)

write_csv(x = working, file = "democrat_bubblechart.csv")  


all_visits <- read.csv("all_visits.csv") %>% 
  filter(candidate_party == "Republican")

working <- all_visits %>% 
  group_by(location, candidate_party) %>%  
  summarize(
    count=n()) %>% 
  filter(count > 4)

write_csv(x = working, file = "republican_bubblechart.csv")  



