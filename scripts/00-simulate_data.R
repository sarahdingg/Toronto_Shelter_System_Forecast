#### Preamble ####
# Purpose: Simulates a dataset of Toronto shelter system flow, with information about people experiencing homelessness who are entering and leaving the shelter system each month
# Author: Sarah Ding
# Date: 29 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# Pre-requisites: The `tidyverse` package must be installed


#### Workspace setup ####
library(tidyverse)

# Set seed for reproducibility
set.seed(123)

# Define population groups
population_groups <- c("single adult", "family", "refugee")

# Create a sequence of dates for each month from 2020 to 2024
dates <- seq(as.Date("2020-01-01"), as.Date("2024-12-01"), by = "month")

# Simulate data for each combination of date and population group
simulated_data <- expand.grid(
  date = dates,
  population_group = population_groups
) %>%
  mutate(
    # Simulate age group data as columns
    ageunder16 = sample(20:100, nrow(.), replace = TRUE),
    `age16-24` = sample(100:300, nrow(.), replace = TRUE),
    `age25-34` = sample(150:350, nrow(.), replace = TRUE),
    `age35-44` = sample(200:400, nrow(.), replace = TRUE),
    `age45-54` = sample(250:450, nrow(.), replace = TRUE),
    `age55-64` = sample(150:300, nrow(.), replace = TRUE),
    age65over = sample(50:150, nrow(.), replace = TRUE),
    
    # Simulate shelter dynamics data
    entered_shelter = sample(100:500, nrow(.), replace = TRUE),
    left_shelter = sample(50:400, nrow(.), replace = TRUE),
    returned_to_shelter = sample(20:150, nrow(.), replace = TRUE),
    moved_to_permanent_housing = sample(30:200, nrow(.), replace = TRUE)
  )

# Display the first few rows of the simulated data
print(head(simulated_data))

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
