# plots

# 1. Workspace ####

library(readr)
library(tidyverse)
library(raster)
library(marmap)
library(leaflet)
library(leafem)
library(dplyr)
# library(leaflet.extras)

rm(list = ls()) # clear workspace

## 1.1. functions ####
source(paste0(getwd(), "/01_code/load_save_rds_files.R"))
source(paste0(getwd(), "/01_code/01_load_data/load_acoustic_detections.R"))
source("C:/Users/lotte.pohl/Documents/github_repos/MasterThesis_LottePohl/01_code/06_functions/ggplot_geom_split_violin.R")

## 1.2 load_data ####

summary_all <- load_data(filestring = "summary_all", folder = paste0(getwd(), "/02_results_plots/"))

n_detect <- sharks_detections %>% 
  group_by(station_name) %>% 
  mutate(count = 1) %>% 
  summarise(n_detect = sum(count))

n_ind <- sharks_detections %>% 
  group_by(station_name) %>%
  summarise(n_ind = tag_serial_number %>% unique() %>% length())

summary_all <- summary_all %>% left_join(n_detect) %>% left_join(n_ind) %>%
  mutate(station_name = factor(station_name))

## chi2 test ####
test <- summary_all$station_name %>% levels()
result <- by(summary_all, summary_all$station_name, function(x) {
  chisq.test(x[, 5:9], x$group)
})

# view results
result

# plots ####
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

summary_wide <- summary_all %>% pivot_longer(cols = starts_with("p"), names_to = "depth_range") %>%
  mutate(depth_range = depth_range %>% factor(levels = c("p_40_50m", "p_30_40m", "p_20_30m", "p_10_20m", "p_0_10m")))


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
  geom_text(aes(x = station_name, y = -30, label = paste0("n =  ", n_detect)), vjust = -1.5, angle = 60) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Min. & max. depth (depth vs shark detections)", 
       x = "Receiver Station", y = "Depth in m", color = "Group")

plot_depth_range

# violin plot with depths
plot_depth_range_heatmap <- ggplot(data = summary_wide,
                                  aes(x = station_name, y = depth_range, fill = value)) + #, color = group
  geom_tile(linewidth = 0.5) +
  facet_grid(vars(group), scales="free_y") +
  # geom_point(aes(x = station_name, y = -min_depth, colour = group)) +
  # geom_point(aes(x = station_name, y = -max_depth, colour = group)) +
  # geom_rect(aes(ymin = -min_depth, ymax = -max_depth, fill = group, x = station_name)) +
  # geom_linerange(aes(ymin = min_depth, ymax = max_depth, x = station_name, color = group), linewidth = 3, alpha = 0.7) +
  theme_minimal(base_size = 12) +
  scale_fill_viridis_c() +
  # scale_y_reverse(labels = c("0-10 m", "10-20 m", "20-30 m", "30-40 m", "40-50 m")) +
  # scale_fill_manual(palette = "RdYlBl") +
  scale_y_discrete(labels = c("40-50 m", "30-40 m", "20-30 m", "10-20 m", "0-10 m")) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(
    title = "Percentage of detections vs depth coverage",
       x = "Receiver Station", y = "Depth bins in m", fill = "Percentage")

plot_depth_range_heatmap


# split violin plot
p_308_vertical_speed_splitviolin <- ggplot(masterias_depth_temp_summary %>% filter(tag_serial_number %in% c("1293308"), vertical_speed_m_min <= 0.5), 
                                           aes(x = monthyear, y = vertical_speed_m_min, fill = day, colour = day)) + 
  geom_split_violin() +
  labs(title = "Tag 308 (female)", y = "vertical speed in m/min", x = "month") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=60, hjust=1))


# sharks_detections %>% filter(station_name == "ws-OG10", sensor_type == "pressure", tag_serial_number == "1293302") %>% View()

plot_sharks_wsOG10 <- ggplot(data = sharks_detections %>% filter(station_name == "ws-OG10", sensor_type == "pressure")) +
  geom_violin(aes(x = tag_serial_number, y = -parameter), fill = "black") +
  # geom_point(aes(x = tag_serial_number, y = -parameter), colour = "lightgrey") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Shark detection depths at station ws-OG10", 
       x = "Tag Serial Number", y = "Depth in m")

plot_sharks_wsOG10

