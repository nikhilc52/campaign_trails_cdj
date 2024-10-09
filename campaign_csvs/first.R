library(dplyr)
library(tidyverse)


df <- read.csv('biden_2020.csv')


working_df <- df %>%
  group_by(state) %>% 
  summarize(
    count = n()
  )

