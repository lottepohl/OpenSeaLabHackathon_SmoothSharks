# plots

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
source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))

## 1.2 load_data ####

summary_all <- load_data(filestring = "summary_all", folder = paste0(getwd(), "/02_results_plots/"))

plot_max_depth <- ggplot(data = summary_all, aes(x = station_name, y = max_depth, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "deepest depth",
       x = "Receiver station", y = "Depth in m", fill = "Group")

# plot_max_depth

plot_min_depth <- ggplot(data = summary_all, aes(x = station_name, y = min_depth, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "shallowest depth",
       x = "Receiver station", y = "Depth in m", fill = "Group")

# plot_min_depth

# plots for the depth ranges at station ws-OG10

summary_wide <- summary_all %>% pivot_longer(cols = starts_with("p"), names_to = "depth_range")

plot_depthbin_ws_OG10 <- ggplot(data = summary_wide %>% filter(station_name == "ws-OG10"),
                                  aes(x = depth_range, y = value, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "station ws-OG10: Depth bin percentage (bathymetry versus acoustic detections)",
       x = "Depth bin", y = "percentage", fill = "Group")

# plot_depthbin_ws_OG10

plot_depth_range <- ggplot(data = summary_all) +
  # geom_point(aes(x = station_name, y = -min_depth, colour = group)) +
  # geom_point(aes(x = station_name, y = -max_depth, colour = group)) +
  # geom_rect(aes(ymin = -min_depth, ymax = -max_depth, fill = group, x = station_name)) +
  geom_linerange(aes(ymin = min_depth, ymax = max_depth, x = station_name, color = group), linewidth = 3, alpha = 0.7) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Min. & max. depth (depth vs shark detections)", 
       x = "Receiver Station", y = "Depth in m", color = "Group")

plot_depth_range

# sharks_detections %>% filter(station_name == "ws-OG10", sensor_type == "pressure", tag_serial_number == "1293302") %>% View()

plot_sharks_wsOG10 <- ggplot(data = sharks_detections %>% filter(station_name == "ws-OG10", sensor_type == "pressure")) +
  geom_violin(aes(x = tag_serial_number, y = -parameter), fill = "black") +
  # geom_point(aes(x = tag_serial_number, y = -parameter), colour = "lightgrey") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Shark detection depths at station ws-OG10", 
       x = "Tag Serial Number", y = "Depth in m")

plot_sharks_wsOG10

