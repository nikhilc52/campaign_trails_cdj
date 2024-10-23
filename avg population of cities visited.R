library(tidyverse)
library(dplyr)
library(ggplot2)

all_visits <- read.csv("all_visits.csv")
cities <- read.csv("us-cities-top-1k.csv")

cities <- cities |>
  mutate(location = paste0(City,", ",State)) |>
  select(location, Population)

all_visits_cities <- all_visits |>
  left_join(cities, join_by(location == location)) |>
  replace_na(list(Population = 25000)) |>
  group_by(candidate_party,year) |>
  summarize(
    candidate = first(candidate),
    average = mean(Population)
  )

ggplot(data = all_visits_cities, 
       aes(x = factor(year), y = average, fill = candidate_party)) + 
  geom_bar(stat = "identity", 
           position = "dodge") +
  labs(x = "Election", 
       y = "Average Population", 
       title = "Average Population of Campaign Stops in Presidential Elections",
       fill = "Party") +
  scale_fill_manual(values = c("Democrat" = "blue", "Republican" = "red")) +
  theme_minimal() +
  theme(
    text = element_text(family = "Arial"),
    plot.title = element_text(margin = margin(b=20),  hjust = 0.45,  face = "bold"),
    axis.title.x = element_text(margin = margin(t = 20)),
    axis.title.y = element_text(margin = margin(r = 20)),
  ) +
  scale_y_continuous(labels = scales::label_number())
