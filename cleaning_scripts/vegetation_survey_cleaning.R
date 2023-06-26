#Packages
library(tidyverse)
library(janitor)
library(readxl)
library(rnrfa)

# Read in data
vegetation_surveys <- 
  read_xlsx(here::here("data/raw_data/Peatland Action - Vegetation surveys spreadsheet.xlsx")) 

# Remove any unnecessary columns and clean names 
vegetation_surveys_trim <- vegetation_surveys %>% 
  select(datasetname, scientificname, eventdate, recordedby, gridreference, 
         locationid, locality, lifestage, vitality, organismquantity)

colnames(vegetation_surveys_trim) <- c("dataset_name", "scientific_name","event_date", 
                                       "recorded_by", "grid_reference", "location_id", 
                                       "locality", "life_stage", "vitality", 
                                       "organism_quantity")

# Add longitude and latitude for each vegetation
vegetation_surveys_trim <- vegetation_surveys_trim %>% 
  mutate(longitude = osg_parse(grid_reference, coord_system = "WGS84")[[1]],
         latitude = osg_parse(grid_reference, coord_system = "WGS84")[[2]], .after = grid_reference)

# Write CSV
write_csv(vegetation_surveys_trim,
          "data/clean_data/vegetation_surveys.csv")




