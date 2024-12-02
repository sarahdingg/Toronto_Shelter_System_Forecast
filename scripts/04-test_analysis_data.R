#### Preamble ####
# Purpose: Tests the analysis data of Toronto Shelter System Flow dataset
# Author: Sarah Ding
# Date: 23 November 2024
# Contact: sarah.ding@mail.utoronto.ca
# License: UofT
# Pre-requisites: 
  #- package `tidyverse` is loaded and installed
  #- analysis_data.parquet is loaded and must have been run
# Any other information needed? N/A


#### Workspace setup ####
# Workspace setup
library(tidyverse)
library(arrow)
library(testthat)

# Load analysis data
analysis_data <- read_parquet(here::here("...data/02-analysis_data/analysis_data.parquet"))

test_that("Dataset is read successfully and contains the expected columns", {
  expect_true(file.exists("data/01-raw_data/raw_data.csv"))
  expect_s3_class(raw_data, "data.frame")
  expect_true(all(c("date(mmm-yy)", "population_group", "population_group_percentage") %in% colnames(raw_data)))
})

test_that("Date column is converted properly", {
  expect_true("date" %in% colnames(cleaned_data))
  expect_s3_class(cleaned_data$date, "Date")
  expect_true(all(!is.na(cleaned_data$date)))
  expect_true(all(format(cleaned_data$date, "%Y") >= 2018)) # Ensure valid years
})

test_that("Data is filtered for the Chronic population group", {
  expect_true(all(chronic_data$population_group == "Chronic"))
  expect_false(any(chronic_data$population_group != "Chronic"))
})

test_that("Population group percentage is numeric and clean", {
  expect_true("population_group_percentage" %in% colnames(chronic_data))
  expect_type(chronic_data$population_group_percentage, "double")
  expect_false(any(is.na(chronic_data$population_group_percentage)))
})

test_that("Interaction terms are calculated and scaled correctly", {
  interaction_columns <- grep("^interaction_", colnames(chronic_data), value = TRUE)
  expect_true(length(interaction_columns) == 7) # Ensure all age groups are included
  
  for (col in interaction_columns) {
    expect_true(!is.null(attr(chronic_data[[col]], "scaled:center")))
    expect_true(!is.null(attr(chronic_data[[col]], "scaled:scale")))
    expect_true(all(!is.na(chronic_data[[col]])))
  }
})

test_that("Final dataset contains expected columns", {
  required_columns <- c(
    "date", "population_group", "returned_to_shelter", "moved_to_housing",
    "actively_homeless", "newly_identified", "ageunder16", "age16-24",
    "age25-34", "age35-44", "age45-54", "age55-64", "age65over",
    "interaction_age_under16_time", "interaction_age16_24_time",
    "interaction_age25_34_time", "interaction_age35_44_time",
    "interaction_age45_54_time", "interaction_age55_64_time",
    "interaction_age65over_time", "population_group_percentage"
  )
  expect_true(all(required_columns %in% colnames(analysis_data)))
})

test_that("Cleaned data is saved successfully as a parquet file", {
  expect_true(file.exists("data/02-analysis_data/analysis_data.parquet"))
  saved_data <- arrow::read_parquet("data/02-analysis_data/analysis_data.parquet")
  expect_s3_class(saved_data, "data.frame")
  expect_true(all(colnames(analysis_data) %in% colnames(saved_data)))
  expect_equal(nrow(analysis_data), nrow(saved_data))
})

test_that("No missing values in key columns", {
  key_columns <- c(
    "date", "returned_to_shelter", "moved_to_housing", "actively_homeless",
    "newly_identified", "population_group_percentage"
  )
  for (col in key_columns) {
    expect_true(all(!is.na(analysis_data[[col]])))
  }
})

test_that("Logical checks for relationships in data", {
  expect_true(all(analysis_data$population_group_percentage >= 0))
  expect_true(all(analysis_data$population_group_percentage <= 100))
  expect_true(all(analysis_data$returned_to_shelter >= 0))
  expect_true(all(analysis_data$newly_identified >= 0))
})


