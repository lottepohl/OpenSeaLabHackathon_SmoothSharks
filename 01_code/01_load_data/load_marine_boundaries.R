# Script to load marine boundaries that were queried from marineregions.org

# 0. workspace ####
data_path <- paste0(getwd(), "/00_data/04_marine_boundaries/")

## 0.1 functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))

# 1. load data ####

eez_belgium <- load_data(filestring = "eez_belgium", folder = data_path)

eez_netherlands <- load_data(filestring = "eez_netherlands", folder = data_path)

country_belgium <- load_data(filestring = "country_belgium", folder = data_path)

country_netherlands <- load_data(filestring = "country_netherlands", folder = data_path)

north_sea_boundaries <- load_data(filestring = "north_sea_boundaries", folder = data_path)

easternscheldt_boundaries <- load_data(filestring = "easternscheldt_boundaries", folder = data_path)

westernscheldt_boundaries <- load_data(filestring = "westernscheldt_boundaries", folder = data_path)

scheldt_boundaries <- load_data(filestring = "scheldt_boundaries", folder = data_path)
