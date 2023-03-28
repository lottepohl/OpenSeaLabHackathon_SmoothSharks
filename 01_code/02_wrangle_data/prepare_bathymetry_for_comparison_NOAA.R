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


# prepare the df ####

radius <- 500 #m

# test <- bathy_belgium %>% head()

bbox <- c(xmin = 3.4, xmax = 3.84, ymin = 51.3, ymax = 51.5)

bathy_belgium_distance <- bathy_belgium %>% #mutate(geometry = st_point(latitude, longitude))
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
receiver_stations_info$station_name
for(i in receiver_stations_info$station_name){
  # get(i)
  
  temp <- bathy_belgium_distance %>% dplyr::select(depth_m, all_of(i)) %>%
    rename (value = i) %>% 
     filter(value == T)
  
  summary <- temp %>% mutate(count = 1) %>%
    summarise(min = min(depth_m), max = max(depth_m),
              p_0_10m = sum(depth_m %>% between(0,10))) # need to work on that
  #depth_m, #%>% filter(isTRUE())
  # bathy_belgium_distance %>% filter())
    # group_by(i) %>%
    # summarise(min_depth = min(depth_m)) %>% View()
}




# test
location <- receiver_stations_info$geometry[[1]] 
# test %>% class()

st_crs(location)

be_crs <- st_crs(32631) #32631

location_transformed <- st_transform(location, be_crs)

circle <- st_buffer(location, dist = radius) #%>% st_sfc(crs = 32631)
circle %>% class()

leaflet() %>% addTiles() %>%
  addScaleBar(position = "topleft", options = scaleBarOptions(maxWidth = 250, imperial = F)) %>%
  addPolygons(data = circle)

st_transform(location,
  crs = st_crs(location))

box = c(xmin = 0, ymin = 0, xmax = 1, ymax = 1)
pol = st_sfc(st_buffer(st_point(c(.5, .5)), .6))
pol_sf = st_sf(a=1, geom=pol)
plot(st_crop(pol, box))
plot(st_crop(pol_sf, st_bbox(box)))


# bathy_crop <- mask(bathy_belgium_raster, circle)
# 
# test <- bathy_belgium_raster %>% as.raster()
