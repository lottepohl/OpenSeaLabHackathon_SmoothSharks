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

## 2.3 load info about acoustic detections ####

source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))


# 2. make map ####

map_overview <- 
  # leaflet(options = leafletOptions(zoomControl = FALSE,
  #                                                        minZoom = 8.5, maxZoom = 8.5,
  #                                                        dragging = FALSE)) %>%
  leaflet() %>%
  setView(3.7, 51.48, zoom = 3) %>%
  addScaleBar(position = "topleft", options = scaleBarOptions(maxWidth = 250, imperial = F)) %>%
  
  addTiles() %>% 
  leafem::addMouseCoordinates() %>%
  addRasterImage(bathy_belgium_raster, opacity = 1, colors = "viridis", group = "bathymetry") %>%
  addCircleMarkers(data = receiver_stations_info,
                   lat = ~deploy_latitude,
                   lng = ~deploy_longitude,
                   radius = 3,
                   fillOpacity = 1,
                   opacity = 1,
                   weight = 0,
                   color = "white") %>%
  # addPolygons(data = eez_netherlands, fillOpacity = 0, opacity = 1, color = "black", weight = 2) %>%
  addPolygons(data = country_belgium, opacity = 1, color = "#ECE4BF", weight = 0.5, fillOpacity = 1, group = "bathymetry") %>%
  addPolygons(data = country_netherlands, opacity = 1, color = "#ECE4BF", weight = 0.5, fillOpacity = 1, group = "bathymetry") %>%
  # addPolygons(data = westernscheldt_boundaries, fillOpacity = 0, opacity = 1, weight = 2, color = "red") %>%
  addPolygons(data = scheldt_boundaries, fillOpacity = 0, opacity = 1, weight = 2, color = "red")


map_overview




