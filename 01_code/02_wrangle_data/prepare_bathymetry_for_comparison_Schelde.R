# script to prepare the fine scale bathymetry for comparison

# 1. Workspace ####

library(readr)
library(tidyverse)
library(raster)
library(marmap)
library(leaflet)
library(leafem)
library(sf)
# library(leaflet.extras)

# rm(list = ls()) # clear workspace

## 1.1. functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))

## 1.2 load bathymetry ####
# source(paste0(getwd(), "/01_code/01_load_data/load_bathymetry_NOAA.R"))

bathy_schelde_fine <- readr::read_csv(file = "C:/Users/lotte.pohl/Documents/github_repos/07_Bathymetry_Schelde/scheldeonthefly3.csv")
# bathy_schelde_fine_raster <- bathy_schelde_fine %>% raster::rasterFromXYZ(crs = "EPSG:4326") # need raster::rasterize()

bathy_schelde_fine <- bathy_schelde_fine %>%
  rename(longitude = `3.398300991`,
         latitude = `51.5022841`,
         depth_m = `10000`) %>%
  mutate(depth_m = depth_m / 100,
         depth_m = ifelse(depth_m == 100, -1, depth_m),
         depth_m = -depth_m) %>%
  filter(depth_m <= 0)



bathy_schelde_fine %>% head(n = 100) %>% View()

## 1.3 load info about acoustic detections ####

source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))


radius <- 200 #m
# i <- "ws-OG10"

summary_bathymetry <- tibble::tibble(station_name = "",
                                     max_depth = NA,
                                     min_depth = NA,
                                     mean_depth = NA,
                                     p_0_10m = NA,
                                     p_10_20m = NA,
                                     p_20_30m = NA,
                                     p_30_40m = NA,
                                     p_40_50m = NA) %>% drop_na()

for(i in receiver_stations_info$station_name){
  
  # Define the input point as a data frame with a single row
  input_point <- receiver_stations_info %>% filter(station_name == i) %>% dplyr::select(deploy_longitude, deploy_latitude)
  
  # Convert the input point to a spatial object
  input_point_sf <- st_as_sf(input_point, coords = c("deploy_longitude", "deploy_latitude"), crs = 4326) #32631
  
  buffer_sf <- st_buffer(input_point_sf, dist = radius) #%>% st_crs(4326)
  
  # Get the coordinates of the buffer as a data frame
  buffer_df <- st_coordinates(buffer_sf) %>% as_tibble() %>% dplyr::select(X, Y) %>% rename(longitude = X, latitude = Y)
  
  # filter out bathy schelde lat longs in proximity of point
  bathy_subset <- bathy_schelde_fine %>% filter(latitude %>% between(buffer_df$latitude %>% min(), buffer_df$latitude %>% max()),
                                                longitude %>% between(buffer_df$longitude %>% min(), buffer_df$longitude %>% max()))
  
  # bathy_subset_raster <- bathy_subset %>% raster::rasterFromXYZ(crs = "EPSG:4326")
  
  summary_temp <- bathy_subset %>%
    dplyr::summarise(
      station_name = i,
      min_depth = max(depth_m),
      max_depth = min(depth_m),
      mean_depth = mean(depth_m),
      p_0_10m = (sum(ifelse(depth_m %>% between(-10,0), 1, 0))   / nrow(bathy_subset)) * 100,# * pixel_area,
      p_10_20m = (sum(ifelse(depth_m %>% between(-20,-10), 1, 0))  / nrow(bathy_subset)) * 100,# * pixel_area,
      p_20_30m = (sum(ifelse(depth_m %>% between(-30,-20), 1, 0))  / nrow(bathy_subset)) * 100,# * pixel_area,
      p_30_40m = (sum(ifelse(depth_m %>% between(-40,-30), 1, 0))  / nrow(bathy_subset)) * 100,# * pixel_area,
      p_40_50m = (sum(ifelse(depth_m %>% between(-50,-40), 1, 0))  / nrow(bathy_subset)) * 100) #* pixel_area)
  
  summary_bathymetry <- summary_bathymetry %>% add_row(summary_temp)
  
}

## save bathymetry summary ####
save_data(data = summary_bathymetry, folder = paste0(getwd(), "/00_data/07_Bathymetry_Schelde/"))

# tests ####

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = input_point_sf) %>%
  addPolygons(data = buffer_sf) %>%
  addCircleMarkers(data = bathy_subset,
                   lat = ~latitude,
                   lng = ~longitude,
                   opacity = 0,
                   fillOpacity = 0,
                   label = ~depth_m) %>%
  addScaleBar(position = "topright", options = scaleBarOptions(maxWidth = 250, imperial = F))

buffer_df$X %>% max()
buffer_df$Y %>% max()

buffer_df$X %>% min()
buffer_df$Y %>% min()
