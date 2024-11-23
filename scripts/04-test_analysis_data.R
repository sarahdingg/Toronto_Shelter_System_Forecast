#### Preamble ####
# Purpose: Tests the analysis data of Toronto Shelter System Flow dataset
# Author: Sarah Ding
# Date: 23 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# License: UofT
# Pre-requisites: 
  #- package `tidyverse` is loaded and installed
  #- analysis_data.csv is loaded and must have been run
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)

cleaned_data <- read_csv("data/02-analysis_data/analysis_data.csv")


# Test 1: Check that all expected columns exist
expected_columns <- c(
  "date", "returned_to_shelter", "moved_to_housing", "actively_homeless",
  "newly_identified", "ageunder16", "age16-24", "age25-34", "age35-44",
  "age45-54", "age55-64", "age65over", "interaction_age_under16_time",
  "interaction_age16_24_time", "interaction_age25_34_time",
  "interaction_age35_44_time", "interaction_age45_54_time",
  "interaction_age55_64_time", "interaction_age65over_time",
  "population_group_percentage"
)
if (all(expected_columns %in% colnames(cleaned_data))) {
  print("Test 1 Passed: All expected columns exist.")
} else {
  missing_cols <- setdiff(expected_columns, colnames(cleaned_data))
  print(paste("Test 1 Failed: Missing columns:", paste(missing_cols, collapse = ", ")))
}

# Test 2: Check that all rows belong to the "Chronic" population group
if (all(cleaned_data$population_group == "Chronic")) {
  print("Test 2 Passed: All rows belong to the 'Chronic' population group.")
} else {
  print("Test 2 Failed: Some rows do not belong to the 'Chronic' population group.")
}

# Test 3: Check that the date column is correctly formatted
if (all(!is.na(as.Date(cleaned_data$date)))) {
  print("Test 3 Passed: Date column is correctly formatted.")
} else {
  print("Test 3 Failed: Date column has invalid entries.")
}

# Test 4: Check for missing values
if (all(!is.na(cleaned_data))) {
  print("Test 4 Passed: No missing values in the dataset.")
} else {
  print("Test 4 Failed: Dataset contains missing values.")
}

# Test 5: Check numeric columns for reasonable ranges
numeric_tests <- list(
  returned_to_shelter = all(cleaned_data$returned_to_shelter >= 0),
  moved_to_housing = all(cleaned_data$moved_to_housing >= 0),
  actively_homeless = all(cleaned_data$actively_homeless >= 0),
  newly_identified = all(cleaned_data$newly_identified >= 0),
  population_group_percentage = all(cleaned_data$population_group_percentage >= 0 & cleaned_data$population_group_percentage <= 100),
  interaction_age_under16_time = all(cleaned_data$interaction_age_under16_time >= 0),
  interaction_age16_24_time = all(cleaned_data$interaction_age16_24_time >= 0),
  interaction_age25_34_time = all(cleaned_data$interaction_age25_34_time >= 0),
  interaction_age35_44_time = all(cleaned_data$interaction_age35_44_time >= 0),
  interaction_age45_54_time = all(cleaned_data$interaction_age45_54_time >= 0),
  interaction_age55_64_time = all(cleaned_data$interaction_age55_64_time >= 0),
  interaction_age65over_time = all(cleaned_data$interaction_age65over_time >= 0)
)

for (col in names(numeric_tests)) {
  if (numeric_tests[[col]]) {
    print(paste("Test 5 Passed:", col, "values are within the expected range."))
  } else {
    print(paste("Test 5 Failed:", col, "values are outside the expected range."))
  }
}

# Test 6: Check that the dataset has at least some data for each age group
if (all(rowSums(cleaned_data[, c("ageunder16", "age16-24", "age25-34", 
                                 "age35-44", "age45-54", "age55-64", 
                                 "age65over")]) > 0)) {
  print("Test 6 Passed: Each row has data for at least one age group.")
} else {
  print("Test 6 Failed: Some rows have no data for any age group.")
}

# Test 7: Check that the interaction terms are consistent with their base values
if (all(cleaned_data$interaction_age16_24_time == cleaned_data$`age16-24` * as.numeric(as.Date(cleaned_data$date)))) {
  print("Test 7 Passed: Interaction terms for age16-24 are consistent.")
} else {
  print("Test 7 Failed: Interaction terms for age16-24 are inconsistent.")
}
