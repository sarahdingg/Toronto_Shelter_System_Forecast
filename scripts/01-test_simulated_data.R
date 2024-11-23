#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Toronto Shelter System Flow dataset.
# Author: Sarah Ding
# Date: 23 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# License: UofT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `Toronto_Shelter_System_Forecast` rproj


#### Workspace setup ####
library(tidyverse)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test 1: Check that all expected columns exist
expected_columns <- c(
  "date", "population_group", "entered_shelter", "left_shelter",
  "returned_to_shelter", "moved_to_permanent_housing", "ageunder16",
  "age16-24", "age25-34", "age35-44", "age45-54", "age55-64", "age65over"
)
if (all(expected_columns %in% colnames(simulated_data))) {
  print("Test 1 Passed: All expected columns exist.")
} else {
  print("Test 1 Failed: Some expected columns are missing.")
}

# Test 2: Check that the population groups are correct
expected_groups <- c("single adult", "family", "refugee")
actual_groups <- unique(simulated_data$population_group)
if (setequal(expected_groups, actual_groups)) {
  print("Test 2 Passed: Population groups are correct.")
} else {
  print("Test 2 Failed: Population groups are incorrect.")
}

# Test 3: Check that date is formatted correctly
if (all(!is.na(as.Date(simulated_data$date)))) {
  print("Test 3 Passed: Date column is correctly formatted.")
} else {
  print("Test 3 Failed: Date column has invalid entries.")
}

# Test 4: Check for missing values
if (all(!is.na(simulated_data))) {
  print("Test 4 Passed: No missing values in the dataset.")
} else {
  print("Test 4 Failed: Dataset contains missing values.")
}

# Test 5: Check that numeric columns have reasonable values
numeric_tests <- list(
  entered_shelter = all(simulated_data$entered_shelter >= 100 & simulated_data$entered_shelter <= 500),
  left_shelter = all(simulated_data$left_shelter >= 50 & simulated_data$left_shelter <= 400),
  returned_to_shelter = all(simulated_data$returned_to_shelter >= 20 & simulated_data$returned_to_shelter <= 150),
  moved_to_permanent_housing = all(simulated_data$moved_to_permanent_housing >= 30 & simulated_data$moved_to_permanent_housing <= 200),
  ageunder16 = all(simulated_data$ageunder16 >= 20 & simulated_data$ageunder16 <= 100),
  `age16-24` = all(simulated_data$`age16-24` >= 100 & simulated_data$`age16-24` <= 300),
  `age25-34` = all(simulated_data$`age25-34` >= 150 & simulated_data$`age25-34` <= 350),
  `age35-44` = all(simulated_data$`age35-44` >= 200 & simulated_data$`age35-44` <= 400),
  `age45-54` = all(simulated_data$`age45-54` >= 250 & simulated_data$`age45-54` <= 450),
  `age55-64` = all(simulated_data$`age55-64` >= 150 & simulated_data$`age55-64` <= 300),
  age65over = all(simulated_data$age65over >= 50 & simulated_data$age65over <= 150)
)

for (col in names(numeric_tests)) {
  if (numeric_tests[[col]]) {
    print(paste("Test 5 Passed:", col, "values are within the expected range."))
  } else {
    print(paste("Test 5 Failed:", col, "values are outside the expected range."))
  }
}

# Test 6: Check that the dataset has the correct number of rows
num_dates <- length(unique(simulated_data$date))
num_groups <- length(unique(simulated_data$population_group))
expected_rows <- num_dates * num_groups
actual_rows <- nrow(simulated_data)
if (actual_rows == expected_rows) {
  print("Test 6 Passed: Dataset has the correct number of rows.")
} else {
  print(paste("Test 6 Failed: Expected", expected_rows, "rows but found", actual_rows, "rows."))
}

