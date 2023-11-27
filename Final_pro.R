library(dplyr)
library(stringr)
library(ggplot2)

pvr_df<- read.csv("hate_crimes.csv")
min_wage_df <- read.csv("MinimumWageData.csv") 

min_wage<- filter(min_wage_df, Year == 2020)
 merged_df <- merge(pvr_df, min_wage, by.x = "state", by.y = "State", all.x = TRUE)
 
merged_df$income_category <- ifelse(merged_df$median_household_income > median(merged_df$median_household_income), "High Income", "Low Income")

merged_df$wage_income_comparison <- merged_df$median_household_income/ merged_df$State.Minimum.Wage
 
unemployment_df <- aggregate(cbind(median_household_income, share_unemployed_seasonal) ~ state, data = merged_df, FUN = mean)
