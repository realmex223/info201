library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(urbnmapr)


pvr_df<- read.csv("hate_crimes.csv")
min_wage_df <- read.csv("MinimumWageData.csv") 

min_wage<- filter(min_wage_df, Year == 2020)
 merged_df <- merge(pvr_df, min_wage, by.x = "state", by.y = "State", all.x = TRUE)
 
merged_df$income_category <- ifelse(merged_df$median_household_income > median(merged_df$median_household_income), "High Income", "Low Income")

merged_df$wage_income_comparison <- merged_df$median_household_income/ merged_df$State.Minimum.Wage
 
unemployment_df <- aggregate(cbind(median_household_income, share_unemployed_seasonal) ~ state, data = merged_df, FUN = mean)

merged_df$share_white <- 1 - merged_df$share_non_white

merged_df$state <- tolower(merged_df$state)

merged_df$state <- tolower(merged_df$state)

# Create a new column with abbreviated state names
merged_df$state_abbr <- state.abb[match(merged_df$state, tolower(state.name))]

merged_df$state_abbr[is.na(merged_df$state_abbr)] <- "D.C"


#this is the file that were going to do all of our data wrangling on 

#story one 
#Chloroplethy map

empty_graph<- ggplot() + 
  geom_polygon(data = urbnmapr::states, mapping = aes(x = long, y = lat, group = group),
               fill = "grey", color = "white") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)
plot(empty_graph)

state_data <- data.frame(
  state = tolower(merged_df$state),  # Convert state names to lowercase
  value = merged_df$median_household_income  # Replace with your actual data
)

# Download state boundaries data from the maps package
state_map <- map_data("state")

# Merge state data with state boundaries
merged_data <- merge(state_map, state_data, by.x = "region", by.y = "state")

# Create a ggplot object
ggplot(merged_data, aes(x = long, y = lat, group = group, fill = value)) +
  geom_polygon(color = "white") +
  coord_map() +
  scale_fill_gradient(name = "Value") +
  theme_minimal()

