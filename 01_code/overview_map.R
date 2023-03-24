# Script to make a leaflet overview map on the study area


# 1. Workspace ####

library(readr)
library(tidyverse)
library(raster)
library(marmap)
library(leaflet)
library(leafem)
# library(leaflet.extras)

rm(list = ls()) # clear workspace

## 1.1. functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))

## 1.2 load bathymetry ####

source(paste0(getwd(), "/01_code/01_load_data/load_bathymetry_NOAA.R"))

## 2.2 load marine boundaries ####

source(paste0(getwd(), "/01_code/01_load_data/load_marine_boundaries.R"))


# 2. make map ####

map_overview <- leaflet() %>%
  addTiles() 

map_overview




