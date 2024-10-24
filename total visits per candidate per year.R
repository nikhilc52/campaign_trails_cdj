library(dplyr)
library(tidyverse)
library(ggplot2)

setwd("~/Documents/GitHub/campaign_trails_cdj/campaign_csvs")
all_visits <- read_csv('all_visits.csv')
setwd("~/Documents/GitHub/campaign_trails_cdj")
cities <- read_csv('us-cities-top-1k.csv')

cities <- cities %>% 
  mutate(location = paste0(City,', ',State)) %>% 
  select(location, Population)

total_visits <- all_visits %>% 
  group_by(candidate_party, year) %>% 
  summarize(
    total = n()
  )

ggplot(data = total_visits, aes(x = factor(year), y = total, fill = candidate_party))+
  geom_bar(stat = "identity", position = "dodge")+
  labs(x = "Year", y = "Number of Visits", title = "Total Visits per Candidate per Year", fill = "Party")+
  scale_fill_manual(values = c("Democrat" = "blue", "Republican" = "red"))+
  theme_minimal()


