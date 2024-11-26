#### Preamble ####
# Purpose: Clean raw_data.csv by splitting `Chronic` population group from all other groups
# Author: Sarah Ding
# Date: 22 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# License: UofT
# Pre-requisites: 
  # -downloaded data is saved to raw_data.csv and have been run
  # -packages `tidyverse`,`lubridate`, `readr` must be installed and loaded
# Any other information needed? N/A

#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(readr)


# Step 1: Read in the dataset
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

# Step 2: Convert the date column to a proper datetime format
cleaned_data <- raw_data %>%
  mutate(date = as.Date(paste0("01-", `date(mmm-yy)`), format = "%d-%b-%y"))

# Step 3: Filter for the Chronic group
chronic_data <- cleaned_data %>%
  filter(population_group == "Chronic")

# Step 4: Clean and convert the population_group_percentage column
chronic_data <- chronic_data %>%
  mutate(
    population_group_percentage = as.numeric(gsub("%", "", population_group_percentage))
  )

# Step 5: Add interaction terms for all age groups (including under 16) and time trends
chronic_data <- chronic_data %>%
  mutate(
    interaction_age_under16_time = scale(ageunder16) * scale(as.numeric(date)),
    interaction_age16_24_time = scale(`age16-24`) * scale(as.numeric(date)),
    interaction_age25_34_time = scale(`age25-34`) * scale(as.numeric(date)),
    interaction_age35_44_time = scale(`age35-44`) * scale(as.numeric(date)),
    interaction_age45_54_time = scale(`age45-54`) * scale(as.numeric(date)),
    interaction_age55_64_time = scale(`age55-64`) * scale(as.numeric(date)),
    interaction_age65over_time = scale(age65over) * scale(as.numeric(date))
  )

# Step 6: Select relevant columns for modeling
analysis_data <- chronic_data %>%
  select(
    date,
    population_group,
    returned_to_shelter,
    moved_to_housing,
    actively_homeless,
    newly_identified,
    ageunder16, `age16-24`, `age25-34`, `age35-44`, `age45-54`, `age55-64`, age65over,
    interaction_age_under16_time, interaction_age16_24_time, interaction_age25_34_time,
    interaction_age35_44_time, interaction_age45_54_time, interaction_age55_64_time,
    interaction_age65over_time,
    population_group_percentage
  )

# Step 7: Check for missing data and handle appropriately
missing_summary <- analysis_data %>% summarise_all(~ sum(is.na(.)))
print(missing_summary)

# Remove attributes from the scaled columns
analysis_data <- analysis_data %>%
  mutate(across(
    starts_with("interaction_"), 
    ~ as.numeric(.)
  ))

# Save the cleaned data
write_csv(analysis_data, "data/02-analysis_data/analysis_data.csv")

# Display a glimpse of the cleaned dataset
glimpse(analysis_data)




