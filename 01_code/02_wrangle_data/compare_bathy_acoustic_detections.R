# Script to compare the acoustic detections and the bathymetry summary

# 1. Workspace ####

library(readr)
library(tidyverse)
library(raster)
library(marmap)
library(leaflet)
library(leafem)
# library(leaflet.extras)

# rm(list = ls()) # clear workspace

## 1.1. functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))

## 1.2 load bathymetry ####

source(paste0(getwd(), "/01_code/01_load_data/load_bathymetry_NOAA.R"))


## 1.3 load info about acoustic detections ####

source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))

## 1.4 load summaries of the acoustic detections and the bathymetry summary ####

### bathymetry ####

summary_bathymetry <- load_data(filestring = "summary_bathymetry", folder = paste0(getwd(), "/00_data/06_Bathymetry_NOAA/"))

### acoustic detections ####

df1 <- read_csv(file = paste0(getwd(), "/00_data/01_acoustic_detections/water_level_parameter.csv"), show_col_types = FALSE)


detections_minmax <- df1 %>% 
  rename(station_name = ...1,
         mean_depth = parameter...2,
         min_depth = parameter...3,
         max_depth = parameter...4) %>%
  drop_na()


df2 <- read_csv(file = paste0(getwd(), "/00_data/01_acoustic_detections/water_level_ranges.csv"), show_col_types = FALSE)

detections_depthrange <- df2 %>%
  pivot_wider(names_from = Group,
              values_from = percentage)
  # rename(p_0_10m = `(-0.001,10.0]`)

summary_detections <- left_join(detections_minmax,
                               detections_depthrange,
                               by = "station_name")

colnames(summary_detections) <- summary_bathymetry %>% colnames() # unify column names
# summary_detections %>% View()

## prepare to join the two dataframes to plot them ####

summary_bathymetry <- summary_bathymetry %>% 
  mutate(group = "bathymetry"())

summary_detections <- summary_detections %>%
  mutate(group = "detections",
         max_depth = max_depth %>% as.numeric,
         min_depth = min_depth %>% as.numeric,
         mean_depth = mean_depth %>% as.numeric,
         p_0_10m = p_0_10m %>% as.numeric(),
         p_10_20m = p_10_20m %>% as.numeric(),
         p_20_30m = p_20_30m %>% as.numeric(),
         p_30_40m = p_30_40m %>% as.numeric(),
         p_40_50m = p_40_50m %>% as.numeric())

summary_all <- full_join(summary_detections,
                         summary_bathymetry) %>%
  filter(station_name %in% summary_detections$station_name,
         station_name %in% receiver_stations_info$station_name) # filter out stations outside of study area

save_data(data = summary_all, folder = paste0(getwd(), "/02_results_plots/"))
write_csv(summary_all, file = paste0(getwd(), "/02_results_plots/summary_all.csv"))

plot_max_depth <- ggplot(data = summary_all, aes(x = station_name, y = max_depth, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 16) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Max. depth comparison between bathymetry and acoustic detections", 
       x = "Receiver station", y = "Depth in m", fill = "Group")

plot_max_depth

plot_min_depth <- ggplot(data = summary_all, aes(x = station_name, y = min_depth, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 16) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Min. depth (bathymetry versus acoustic detections)", 
       x = "Receiver station", y = "Depth in m", fill = "Group")

plot_min_depth

# plots for the depth ranges at station ws-OG10

summary_wide <- summary_all %>% pivot_longer(cols = starts_with("p"), names_to = "depth_range")

plot_depthbin_ws_OG10 <- ggplot(data = summary_wide %>% filter(station_name == "ws-OG10"), 
                                  aes(x = depth_range, y = value, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal(base_size = 16) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "station ws-OG10: Depth bin percentage (bathymetry versus acoustic detections)", 
       x = "Depth bin", y = "percentage", fill = "Group")

plot_depthbin_ws_OG10

# make overview map ####

sharks_detections %>% group_by(station_name) %>%
  summarise(n_detect = n()) %>% View()
