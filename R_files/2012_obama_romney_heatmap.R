library(ggplot2)
library(dplyr)
library(maps)

# Load the datasets
obama_data <- read.csv("obama_2012.csv")
romney_data <- read.csv("romney_2012.csv")

# Add candidate column 
obama_data <- obama_data %>% mutate(Candidate = "Obama")
romney_data <- romney_data %>% mutate(Candidate = "Romney")

combined_data <- rbind(obama_data, romney_data)

# Remove rows with missing state names
combined_data <- combined_data %>% filter(!is.na(state))

combined_data$state <- tolower(combined_data$state)

usa_map <- map_data("state")

# Group by state and candidate for calculating number of events per state
events_per_state <- combined_data %>%
  group_by(state, Candidate) %>%
  summarise(EventCount = n()) %>%
  ungroup()

obama_events <- events_per_state %>% filter(Candidate == "Obama")
romney_events <- events_per_state %>% filter(Candidate == "Romney")

obama_map_data <- merge(usa_map, obama_events, by.x = "region", by.y = "state", all.x = TRUE)
romney_map_data <- merge(usa_map, romney_events, by.x = "region", by.y = "state", all.x = TRUE)

# Fill NA values in EventCount with 0 for states without events
obama_map_data$EventCount[is.na(obama_map_data$EventCount)] <- 0
romney_map_data$EventCount[is.na(romney_map_data$EventCount)] <- 0

obama_map_data <- obama_map_data %>% arrange(group, order)
romney_map_data <- romney_map_data %>% arrange(group, order)

# Plot Obama's heatmap
obama_plot <- ggplot(data = obama_map_data, aes(x = long, y = lat, group = group, fill = EventCount)) +
  geom_polygon(color = "black", size = 0.2) +
  scale_fill_gradient(low = "white", high = "darkblue", na.value = "gray90") +
  coord_fixed(1.3) +
  labs(title = "2012 Obama Campaign Event Intensity by State",
       fill = "Number of Events") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        legend.position = "bottom")

# Plot Romney's heatmap
romney_plot <- ggplot(data = romney_map_data, aes(x = long, y = lat, group = group, fill = EventCount)) +
  geom_polygon(color = "black", size = 0.2) +
  scale_fill_gradient(low = "white", high = "darkred", na.value = "gray90") +
  coord_fixed(1.3) +
  labs(title = "2012 Romney Campaign Event Intensity by State",
       fill = "Number of Events") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        legend.position = "bottom")

# Print both plots
print(obama_plot)
print(romney_plot)
