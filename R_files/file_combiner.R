#import libraries
library(tidyverse)
library(dplyr)

#list of data to append
list <- list('trump_2020','biden_2020','clinton_2016','trump_2016','romney_2012',
             'obama_2012','obama_2008','mccain_2008', 'bush_2004','kerry_2004')

#make an empty data frame to append to
data <- data.frame()
for(i in list){
  temp_data <- read_csv(paste0(i,'.csv'), show_col_types = FALSE)
  #add a column for the candidate and the year
  temp_data$candidate <- tools::toTitleCase(sub("(.*)_(.*)", "\\1", i))
  temp_data$year <- sub(".*_(.*)", "\\1", i)
  temp_data$candidate_party <- ifelse(i %in% c('trump_2020','trump_2016','romney_2012','mccain_2008','bush_2004'),"Republican","Democrat")
  data <- rbind(data, temp_data)
  print(paste0('Reading and appending: ',i,'.csv'))
}

write_csv(data,'all_visits.csv')
