# Script to load the acoustic detections

## 1.1. functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))

receiver_deployments <- load_data(filestring = "receiver_deployments", folder = paste0(getwd(), "/00_data/01_acoustic_detections/"))
receiver_stations_info <- load_data(filestring = "receiver_stations_info", folder = paste0(getwd(), "/00_data/01_acoustic_detections/"))
sharks_detections <- load_data(filestring = "sharks_detections", folder = paste0(getwd(), "/00_data/01_acoustic_detections/"))
receiver_deployments <- load_data(filestring = "receiver_deployments", folder = paste0(getwd(), "/00_data/01_acoustic_detections/"))
sharks_info <- load_data(filestring = "sharks_info", folder = paste0(getwd(), "/00_data/01_acoustic_detections/"))
