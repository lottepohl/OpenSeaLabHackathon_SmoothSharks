# Script to prepare the acoustic detection data for the comparison with the Bathymetry

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


## 1.3 load info about acoustic detections ####

source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))

bathy_schelde_fine <- read_csv(file = paste0(getwd(), "/00_data/07_Bathymetry_Schelde/scheldeonthefly3.csv"))
# bahty_schelde_fine <- bathy_schelde_fine
# rm(bahty_schelde_fine)

bathy_schelde_fine %>% head() %>% View()
# bathy_schelde_fine %>% colnames()

bathy_schelde_fine <- bathy_schelde_fine %>%
  # rename(latitude = `3.398300991`,
  #        longitude = `51.5022841`,
  #         depth_m = `10000`) %>%
  mutate( depth_m = depth_m / 100)


# prepare the df ####

radius <- 500 #m
pixel_area <- 250 * 250 #m


# test <- bathy_belgium %>% head()

bbox <- c(xmin = 3.4, xmax = 3.84, ymin = 51.3, ymax = 51.5)

bathy_belgium_distance <- bathy_schelde_fine %>% #mutate(geometry = st_point(latitude, longitude))
  mutate(st_as_sf(., coords = c("longitude", "latitude"), crs = st_crs(4326))) %>% 
  filter(latitude %>% between(bbox[[3]], bbox[[4]]),
         longitude %>% between(bbox[[1]], bbox[[2]]))


for(i in 1:nrow(receiver_stations_info)){
  station_name <- receiver_stations_info$station_name[i]
  coords <- receiver_stations_info$geometry[i]
  
  dist <- st_distance(bathy_belgium_distance$geometry, coords) %>% as.numeric() %>%
    tibble::as_tibble() %>% 
    dplyr::rename(distance_m = value) 
  inside_radius <- ifelse(dist$distance_m < radius, TRUE, FALSE) %>% tibble::as_tibble()
  colnames(inside_radius) <- station_name
  
  bathy_belgium_distance <- bathy_belgium_distance %>% cbind(inside_radius)
}

## make summary dataframe ####

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
  # get(i)
  
  temp <- bathy_belgium_distance %>% dplyr::select(depth_m, all_of(i)) %>%
    rename (value = i) %>% 
     filter(value == T) %>%
    mutate(depth_m = depth_m %>% abs())
  
  
  summary_temp <- temp %>%
    dplyr::summarise(
      station_name = i,
      min_depth = min(depth_m),
      max_depth = max(depth_m),
      mean_depth = mean(depth_m),
      p_0_10m = (sum(ifelse(depth_m %>% between(0,10), 1, 0))   / nrow(temp)),# * pixel_area,
      p_10_20m = (sum(ifelse(depth_m %>% between(10,20), 1, 0)) / nrow(temp)),# * pixel_area,
      p_20_30m = (sum(ifelse(depth_m %>% between(20,30), 1, 0)) / nrow(temp)),# * pixel_area,
      p_30_40m = (sum(ifelse(depth_m %>% between(30,40), 1, 0)) / nrow(temp)),# * pixel_area,
      p_40_50m = (sum(ifelse(depth_m %>% between(40,50), 1, 0)) / nrow(temp))) #* pixel_area)
  
  summary_bathymetry <- summary_bathymetry %>% add_row(summary_temp)
}

## save bathymetry summary ####
save_data(data = summary_bathymetry, folder = paste0(getwd(), "/00_data/06_Bathymetry_NOAA/"))


# old ####
# #depth_m, #%>% filter(isTRUE())
# # bathy_belgium_distance %>% filter())
# # group_by(i) %>%
# # summarise(min_depth = min(depth_m)) %>% View()
# 
# # test
# location <- receiver_stations_info$geometry[[1]] 
# # test %>% class()
# 
# st_crs(location)
# 
# be_crs <- st_crs(32631) #32631
# 
# location_transformed <- st_transform(location, be_crs)
# 
# circle <- st_buffer(location, dist = radius) #%>% st_sfc(crs = 32631)
# circle %>% class()
# 
# leaflet() %>% addTiles() %>%
#   addScaleBar(position = "topleft", options = scaleBarOptions(maxWidth = 250, imperial = F)) %>%
#   addPolygons(data = circle)
# 
# st_transform(location,
#   crs = st_crs(location))
# 
# box = c(xmin = 0, ymin = 0, xmax = 1, ymax = 1)
# pol = st_sfc(st_buffer(st_point(c(.5, .5)), .6))
# pol_sf = st_sf(a=1, geom=pol)
# plot(st_crop(pol, box))
# plot(st_crop(pol_sf, st_bbox(box)))
# 
# 
# # bathy_crop <- mask(bathy_belgium_raster, circle)
# # 
# # test <- bathy_belgium_raster %>% as.raster()
