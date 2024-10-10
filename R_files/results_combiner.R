#import libraries
library(tidyverse)
library(dplyr)

#list of data to append
list <- list('2016_results','2012_results','2008_results','2004_results')

#make an empty data frame to append to
data <- read_csv(paste0('2020_results','.csv'), show_col_types = FALSE)
for(i in list){
  temp_data <- read_csv(paste0(i,'.csv'), show_col_types = FALSE) |> 
    select(-electoral_votes)
  data <- left_join(data, temp_data, join_by(state==state))
  print(paste0('Reading and joining: ',i,'.csv'))
}

write_csv(data,'all_results.csv')
