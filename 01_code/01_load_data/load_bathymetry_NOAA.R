# Script to load bathymetry data queried from NOAA (with the `marmap` R package)

library(dplyr)
library(raster)
library(readr)


bathy_belgium <- read_csv(paste0(getwd(),"/00_data/06_Bathymetry_NOAA/marmap_coord_1.9;50.9;4.7;52.4_res_0.25.csv"), show_col_types = F) %>% 
  rename(longitude = V1, latitude = V2, depth_m = V3)

bathy_belgium_raster <- bathy_belgium %>% raster::rasterFromXYZ(crs = "EPSG:4326") # rasterise with `raster` package

# rm(bathy_belgium) # file not needed anymore

