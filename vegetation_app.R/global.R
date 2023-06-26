library(tidyverse)

# Load data
vegetation_surveys <- read_csv(here::here("data/clean_data/vegetation_surveys.csv"))

# INTERMEDIATE VARIABLES
locality_choices <- unique(vegetation_surveys$locality)
dataset_choices <- unique(vegetation_surveys$dataset_name)

