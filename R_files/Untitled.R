library(tidyverse)
library(dplyr)
library(ggplot2)

#read in data (all_visits.csv)
#filter(candidate_party == "d/r")
#group by location, summarize(count = n()) 
#write_csv("name", data)
#final output: number of visits, location, candidate party (two separate)

all_visits <- read.csv("all_visits.csv") %>% 
  filter(candidate_party == "Democrat")

working <- all_visits %>% 
  group_by(location, candidate_party) %>%  
         summarize(
           count=n()) %>% 
  filter(count > 4)

write_csv(x = working, file = "democrat_bubblechart.csv")  

