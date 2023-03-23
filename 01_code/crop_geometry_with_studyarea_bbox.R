# Script to crop geometries, e.g. from environmental layers, to the study area extend
library(sf)

# crop geometries
crop_geom <- function(geom, bbox){
  cropped_geom <- sf::st_crop(geom, bbox)
  return(cropped_geom)
}
bbox_geom <- c(xmin = 3.26, ymin = 51.32, xmax = 4.24, ymax = 51.55)
