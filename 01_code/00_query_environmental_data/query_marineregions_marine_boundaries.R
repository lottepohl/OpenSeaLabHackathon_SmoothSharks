# Script to get marine boundaries from the marine regions databas (marineregions.org)
# browse regions and get their MRGID (Marine Region Geographic ID = unique identifier)

# 0. workspace ####
library(devtools)
devtools::install_github("lifewatch/mregions2")
library(mregions2)

source(paste0(getwd(), "/01_code/load_save_rds_files.R")) # load functions to save and load lightweight files (.rds)
# source(paste0(getwd(), "/01_code/crop_geometry_with_studyarea_bbox.R")) # load functions to crop geometries to the study area bounding box

data_path <- paste0(getwd(), "/00_data/04_marine_boundaries/")

# 1. get data ####

## EEZs: Netherlands and Belgium ####
eez_belgium <- mregions2::gaz_search(3293) %>% mregions2::gaz_geometry()
eez_netherlands <- mregions2::gaz_search(5668) %>% mregions2::gaz_geometry()

## Country boundaries: Netherlands and Belgium ####

country_belgium <- mregions2::gaz_search(14) %>% mregions2::gaz_geometry()
country_netherlands <- mregions2::gaz_search(15) %>% mregions2::gaz_geometry()

## boundaries Scheldt Estuary: Eastern and Western Scheldt, North Sea ####

north_sea_boundaries <- mregions2::gaz_search(2350) %>% mregions2::gaz_geometry()
easternscheldt_boundares <- mregions2::gaz_search(5332) %>% mregions2::gaz_geometry()
westernscheldt_boundaries <- mregions2::gaz_search(4752) %>% mregions2::gaz_geometry()
scheldt_boundaries <- mregions2::gaz_search(4812) %>% mregions2::gaz_geometry()

# 2. save data ####

save_data(data = country_belgium, folder = data_path)
save_data(data = eez_belgium, folder = data_path)
save_data(data = country_netherlands, folder = data_path)
save_data(data = eez_netherlands, folder = data_path)
save_data(data = north_sea_boundaries, folder = data_path)
save_data(data = easternscheldt_boundares, folder = data_path)
save_data(data = westernscheldt_boundaries, folder = data_path)
save_data(data = scheldt_boundaries, folder = data_path)
