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
  scale_fill_gradient(name = "Median Household Income",low = "lightblue", high = "darkblue" ) +
  theme_minimal()

merged_df$state <- tolower(merged_df$state)

# Create a new column with abbreviated state names
merged_df$state_abbr <- state.abb[match(merged_df$state, tolower(state.name))]

merged_df$state_abbr[is.na(merged_df$state_abbr)] <- "D.C"


# Create the final plot with state abbreviations and a nicer theme
final_plot <- ggplot(merged_df, aes(x = median_household_income, y = share_population_with_high_school_degree, label = state_abbr)) +
  geom_point(color = "darkblue", size = 3, alpha = 0.7) +
  geom_text(vjust = -0.5, hjust = 1, size = 3, color = "black") +
  labs(title = "Median Household Income vs. Share of Population with High School Degree",
       x = "Median Household Income",
       y = "Share Population with High School Degree") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.position = "none")

