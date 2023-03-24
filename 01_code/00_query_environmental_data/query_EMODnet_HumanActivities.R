# Get environmental layers With EMODnetWFS R package ####
# following this tutorial: https://emodnet.github.io/EMODnetWFS/

# 0. workspace ####

# library(devtools)
# devtools::install_github("EMODnet/EMODnetWFS")
library(sf)
library(EMODnetWFS)
library(leaflet)
library(purrr)
library(dplyr)

source(paste0(getwd(), "/01_code/load_save_rds_files.R")) # load functions to save and load lightweight files (.rds)
source(paste0(getwd(), "/01_code/crop_geometry_with_studyarea_bbox.R")) # load functions to crop geometries to the study area bounding box

data_path <- paste0(getwd(), "/00_data/03_EMODnet/")

# 1. view available webservices ####

# View(emodnet_wfs())

# 2. initiate clients ####

# wfs_bio <- emodnet_init_wfs_client(service = "biology")
wfs_human <- emodnet_init_wfs_client(service = "human_activities")


# 3. get overview on available layers ####

# wfs_human %>% emodnet_get_wfs_info() %>% View()

# layers_cables <- wfs_human %>% emodnet_get_layers(layers = "pcablesrijks")
# layer_names_human <- c("eeacoastline", "eez", "faoareas", "maritimebnds", "portvessels", "natura2000areas", "wdpaareas", "ospar", "oenergy")

# 4. get layers ####

# EEZs <- wfs_human %>% emodnet_get_layers(layers = "eez", crs = 4326) 
# EEZs$eez$country %>% unique()
# EEZs %>% as.data.frame() # %>% filter(EEZs$eez$country == "Netherlands")

## shellfish production ####
shellfishproduction <- wfs_human %>% 
  emodnet_get_layers(layers = "shellfish", crs = 4326) %>% 
  purrr::pluck("shellfish") %>%
  filter(country == "Netherlands") %>% 
  crop_geom(bbox = bbox_geom)

cables_telecommunication <- wfs_human %>% 
  emodnet_get_layers(layers = "rijkscables", crs = 4326) %>% 
  purrr::pluck("rijkscables") %>% 
  crop_geom(bbox = bbox_geom)


cables_power_windfarms <- wfs_human %>% 
  emodnet_get_layers(layers = "pcablesrijks", crs = 4326) %>% 
  purrr::pluck("pcablesrijks") %>%
  crop_geom(bbox = bbox_geom)

# natura2000_areas <- wfs_human %>% emodnet_get_layers(layers = "natura2000areas", crs = 4326) # too large...

port_vesseltraffic <- wfs_human %>% emodnet_get_layers(layers = "portvessels", crs = 4326) # NULL


dreding_areas <- wfs_human %>% emodnet_get_layers(layers = "dredging", crs = 4326) %>%
  purrr::pluck("dredging") %>% 
  dplyr::filter(year_ == 2019) %>%
  crop_geom(bbox = bbox_geom)

# dredging_spoil <- wfs_human %>% emodnet_get_layers(layers = "dredgespoilpoly", crs = 4326) %>% # no entries in the study area
  # purrr::pluck("dredgespoilpoly")

test <- dredging_spoil %>% 
  purrr::pluck("dredgespoilpoly") #%>%
  # dplyr::filter(year_opera == 2019) #%>%
  # crop_geom(bbox = bbox_geom)


bathing_waters <- wfs_human %>% emodnet_get_layers(layers = "bathingwaters", crs = 4326)



# 3. save data


# 4. briefly visualise layers
library(leafem)

leaflet() %>% addTiles() %>%
  addRectangles(lng1 = bbox_geom[[1]], lat1 = bbox_geom[[2]], lng2 = bbox_geom[[3]], lat2 = bbox_geom[[4]],
                fillOpacity = 0) %>%
  addCircleMarkers(data = test) %>%
  # addPolylines(data = test) %>%
  leafem::addMouseCoordinates()


