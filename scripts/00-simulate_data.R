#### Preamble ####
# Purpose: Simulates a dataset of Toronto shelter system flow, with information about people experiencing homelessness who are entering and leaving the shelter system each month
# Author: Sarah Ding
# Date: 29 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# Pre-requisites: The `tidyverse` package must be installed


#### Workspace setup ####
library(tidyverse)
set.seed(853)
##changessssss


#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")
