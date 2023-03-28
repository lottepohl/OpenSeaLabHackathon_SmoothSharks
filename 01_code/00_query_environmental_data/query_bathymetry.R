library(sf) # simple features packages for handling vector GIS data
library(httr) # generic webservice package
library(tidyverse) # a suite of packages for data wrangling, transformation, plotting, ...
library(ows4R) # interface for OGC webservices

# 
# wfs_url <- "https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/ows?SERVICE=WMS&"
# 
# wfs <- "https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/ows"
# 
# url_scheldebathy <- parse_url(wfs_url)
# 
# # url <- parse_url(wfs_bwk)
# url_scheldebathy$query <- list(service = "wfs",
#                   #version = "2.0.0", # facultative
#                   request = "GetCapabilities"
# )
# request <- build_url(url_scheldebathy)
# request
# 
# schelde_client <- WFSClient$new(wfs, 
#                             serviceVersion = "2.0.1") #serviceVersion must be provided here
# 
# wfs_regions <- "https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/wcs"  #"https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/ows" #?service=WMS&request=GetLegendGraphic&format=image%2Fpng&width=20&height=20&layer=ScheldeOnTheFly&style=negatief_neerwaarts_nap" #"https://eservices.minfin.fgov.be/arcgis/services/R2C/Regions/MapServer/WFSServer"
# regions_client <- WFSClient$new(wfs_regions, 
#                                 serviceVersion = "2.0.0")
# 
# regions_client$getFeatureTypes(pretty = TRUE)
# 
# schelde_client
# regions_client$getFeatureTypes(pretty = TRUE)
# 
# 
# wfs_regions <- "https://eservices.minfin.fgov.be/arcgis/services/R2C/Regions/MapServer/WFSServer"
# regions_client <- WFSClient$new(wfs_regions, 
#                                 serviceVersion = "2.0.0")
# regions_client$getFeatureTypes(pretty = TRUE)
# 
# url <- parse_url(wfs_regions)
# url$query <- list(service = "wfs",
#                   #version = "2.0.0", # optional
#                   request = "GetFeature",
#                   typename = "regions",
#                   srsName = "EPSG:4326"
# )
# request <- build_url(url)
# 
# bel_regions <- read_sf(request) #Lambert2008

rm(list = ls())

# original ####
wfs_bwk1 <- "https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs"

url1 <- parse_url(wfs_bwk1)
url1$query <- list(service = "wfs",
                  #version = "2.0.0", # facultative
                  request = "GetCapabilities"
)
request1 <- build_url(url1)
request1

bwk_client1 <- WFSClient$new(wfs_bwk1, 
                            serviceVersion = "2.0.0") #serviceVersion must be provided here
bwk_client1

bwk_client1$getFeatureTypes(pretty = TRUE)

# our data ####

wfs_bwk2 <- "https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/ows"
url2 <- parse_url(wfs_bwk2)
url2$query <- list(service = "wcs",
                   #version = "2.0.0", # facultative
                   request = "GetCapabilities"
)
request2 <- build_url(url2)
request2

bwk_client2 <- WFSClient$new(wfs_bwk2, 
                             serviceVersion = "2.0.0") #serviceVersion must be provided here

bwk_client2

bwk_client2$getFeatureTypes(pretty = TRUE)


# new try #####

WCS <- WCSClient$new("https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/wcs?", "2.1.0", logger = "INFO")

caps <- WCS$getCapabilities()
caps
chla <- caps$findCoverageSummaryById("DMT__ScheldeOnTheFly", exact = T)
chla

chla_des <- chla$getDescription()
chla_des

cov <- vliz$getCapabilities()$findCoverageSummaryById("Emodnetbio__aca_spp_19582016_L1", exact = TRUE)

vliz <- WCSClient$new(url = "https://bathgrid.vlaanderen.be/geoserver/DMT/ScheldeOnTheFly/wcs?", serviceVersion = "2.1.0", logger = "INFO")
cov <- vliz$getCapabilities()$findCoverageSummaryById("DMT__ScheldeOnTheFly", exact = TRUE)
cov
cov_des <- cov$getDescription()
cov_data <- cov$getCoverage(
  bbox = OWSUtils$toBBOX(8.37,8.41,58.18,58.24),
  time = cov$getDimensions()[[3]]$coefficients[1]
)
cov_data_stack <- cov$getCoverageStack(
  bbox = OWSUtils$toBBOX(8.37,8.41,58.18,58.24),
  time = cov$getDimensions()[[3]]$coefficients[1]
)
