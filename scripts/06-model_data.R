#### Preamble ####
# Purpose: Models the Toronto shelter system's performance on reducing chronic homelessness
# Author: Sarah Ding
# Date: 29 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# License: MIT
# Pre-requisites: library `tidyverse`, `arrow`, `readr` must be loaded and installed
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)
library(arrow)
library(readr)

# Load the cleaned analysis data
analysis_data <- arrow::read_parquet("data/02-analysis_data/analysis_data.parquet")

# Step 1: Select relevant columns for modeling (no scaling)
model_data <- analysis_data %>%
  select(
    date,
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

# Step 2: Fit the model directly without scaling
model_toronto <- lm(
  formula = moved_to_housing ~ 
    returned_to_shelter + 
    actively_homeless + 
    newly_identified + 
    population_group_percentage + 
    ageunder16 + `age16-24` + `age25-34` + `age35-44` + `age45-54` + `age55-64` + age65over + 
    interaction_age_under16_time + interaction_age16_24_time + interaction_age25_34_time + 
    interaction_age35_44_time + interaction_age45_54_time + interaction_age55_64_time + 
    interaction_age65over_time,
  data = model_data
)

# Step 3: Save the model data without scaling
saveRDS(model_toronto, "models/model_toronto.rds")
