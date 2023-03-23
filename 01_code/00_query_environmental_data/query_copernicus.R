# Get environmental layers With CopernicusMarine R package ####
# following this tutorial: https://github.com/pepijn-devries/CopernicusMarine

# 0. workspace ####

# library(devtools)
# devtools::install_github("pepijn-devries/CopernicusMarine")
library(sf)
library(CopernicusMarine)
library(leaflet)
library(purrr)
library(dplyr)

source(paste0(getwd(), "/01_code/load_save_rds_files.R")) # load functions to save and load lightweight files (.rds)
source(paste0(getwd(), "/01_code/crop_geometry_with_studyarea_bbox.R")) # load functions to crop geometries to the study area bounding box

data_path <- paste0(getwd(), "/00_data/05_Copernicus_temp_sal/")

## setup CopernicusMarine environment

options(CopernicusMarine_uid = "lpohl")
options(CopernicusMarine_pwd = "YXef$mWkFA9UsAU")
# destination <- tempfile("copernicus", fileext = ".nc") # from tutorial

salinity_2021 <- copernicus_download_motu(
  destination   = paste0(data_path, "salinity_2021.nc"),
  product       = "IBI_ANALYSISFORECAST_PHY_005_001",
  layer         = "cmems_mod_ibi_phy_anfc_0.027deg-3D_P1M-m", # should be cmems_mod_ibi_phy_anfc_0.027deg-3D_P1D-m
  variable      = "sea_water_salinity",
  output        = "netcdf",
  region        = c(bbox_geom[[1]], bbox_geom[[2]], bbox_geom[[3]], bbox_geom[[4]]),
  timerange     = c("2021-04-01", "2021-11-01"), # should be c("2019-05-04", "2019-01-11")
  verticalrange = c(0, 100),
  # sub_variables = c("uo", "vo")
)

temperature_2021 <- copernicus_download_motu(
  destination   = paste0(data_path, "temperature_2021.nc"),
  product       = "IBI_ANALYSISFORECAST_PHY_005_001",
  layer         = "cmems_mod_ibi_phy_anfc_0.027deg-3D_P1M-m", # should be cmems_mod_ibi_phy_anfc_0.027deg-3D_P1D-m
  variable      = "sea_water_temperature",
  output        = "netcdf",
  region        = c(bbox_geom[[1]], bbox_geom[[2]], bbox_geom[[3]], bbox_geom[[4]]),
  timerange     = c("2021-04-01", "2021-11-01"), # should be c("2019-05-04", "2019-01-11")
  verticalrange = c(0, 100),
  # sub_variables = c("uo", "vo")
)


# map data

leaflet::leaflet() %>%
  leaflet::setView(lng = 3, lat = 54, zoom = 4) %>%
  leaflet::addProviderTiles("Esri.WorldImagery") %>%
  CopernicusMarine::addCopernicusWMSTiles(
    product     = "IBI_ANALYSISFORECAST_PHY_005_001",
    layer       = "cmems_mod_ibi_phy_anfc_0.027deg-3D_P1D-m",
    variable    = "thetao"
  )
