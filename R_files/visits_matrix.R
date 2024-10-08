#import libraries
library(tidyverse)
library(dplyr)

setwd("~/GitHub/campaign_trails_cdj/campaign_csvs")
all_visits <- read_csv('all_visits.csv')

setwd("~/GitHub/campaign_trails_cdj/results_csvs")
all_results <- read_csv('all_results.csv') |> 
  select(state, winner_2020, winner_2016, winner_2012, winner_2008, winner_2004)

all_visits_state <- all_visits |> 
  group_by(state, candidate, year) |> 
  summarize(visits=n()) |> 
  mutate(candidate_year = paste0(candidate,'_',year)) |> 
  pivot_wider(id_cols=state, names_from = candidate_year, values_from = visits)

all_visits_state[is.na(all_visits_state)] <- 0

visits_results <- inner_join(all_results, all_visits_state, join_by(state == state))

matrix <- function(winner_year, candidate1_year, candidate2_year){
  temp <- visits_results |> 
    select(state, winner_year, candidate1_year, candidate2_year) |> 
    rename(c2v = candidate2_year) |> 
    rename(c1v = candidate1_year) |> 
    rename(winner = winner_year) |> 
    filter(c2v > 5 | c1v > 5) #subject to change
    
    c1 = tools::toTitleCase(sub("(.*)_(.*)", "\\1", candidate1_year))
    c2 = tools::toTitleCase(sub("(.*)_(.*)", "\\1", candidate2_year))
    
    temp <- temp |> 
      mutate(more_won = ifelse((c2v > c1v & winner == c2) | 
                                        (c2v < c1v & winner == c1),1,0)) |> 
      mutate(less_won = ifelse((c2v > c1v & winner == c1) | 
                                 (c2v < c1v & winner == c2),1,0)) |> 
      mutate(tie_c1 = ifelse((c1v == c2v & winner == c1), 1,0)) |> 
      mutate(tie_c2 = ifelse((c1v == c2v & winner == c2), 1,0))
  
  print(paste0('Campaigned more and won (n): ',sum(temp$more_won)))
  print(paste0('Campaigned less and won (n): ',sum(temp$less_won)))
  print(paste0(c1, ' won (n) even: ',sum(temp$tie_c1)))
  print(paste0(c2, ' won (n) even: ',sum(temp$tie_c2)))
  print(paste0('Total states visited: ', nrow(temp)))
}

matrix('winner_2004', 'Bush_2004', 'Kerry_2004')
matrix('winner_2008', 'Obama_2008', 'Mccain_2008')
matrix('winner_2012', 'Obama_2012', 'Romney_2012')
matrix('winner_2016', 'Clinton_2016', 'Trump_2016')
matrix('winner_2020', 'Biden_2020', 'Trump_2020')


