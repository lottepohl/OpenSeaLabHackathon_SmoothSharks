# Loading of the different libraries
library(ncdf4)
library(lubridate)
library(RColorBrewer)
library(lattice)

## Set the working directory and filename
setwd("./mydirectory/")
nc_file <- nc_open("CMEMS-MEDSEA_006_013-bottomT_thetao-2020.nc")
print(nc_file)


## Structure of the .nc file
names(nc_file)

# Names of the variables
names(nc_file$var)
# Names of the dimensions
names(nc_file$dim)

## Get Coordinate variables
longitude <- nc_file$dim[[4]]$vals
latitude <- nc_file$dim[[3]]$vals
time <- nc_file$dim[[2]]$vals
depth <- nc_file$dim[[1]]$vals

# Number of variable's values
nlon <- dim(longitude)
nlat <- dim(latitude)
nd <- dim(depth)

print(c(nlon,nlat,nd)) #to have them all

## Get time variable
time
# Number of time steps
nt <- dim(time)
nt
# Time units attribute
t_units <- ncatt_get(nc_file, "time", "units")
t_units

## Get an ocean variable
names(nc_file$var)

#sea_water_potential_temperature
T_array <- ncvar_get(nc_file,nc_file$var[[1]])
T_array
T <- "thetao" 

#variable's attributes
ncatt_get(nc_file, T, "long_name")   #long name
ncatt_get(nc_file, T, "units")       #measure unit
fillvalue <- ncatt_get(nc_file, T, "_FillValue")  #(optional)


## Time variable conversion
# convert time -- split the time units string into fields
t_ustr <- strsplit(t_units$value, " ")
t_dstr <- strsplit(unlist(t_ustr)[3], "-")
date <- ymd(t_dstr) + dminutes(time)
date

## Quick Map Plot
# set the time step
t <- 1 #temperature on 2020-01-16
T_slice <- T_array[,,t]

# Plot a map
image(longitude,latitude,T_slice, col = rev(brewer.pal(10,"RdBu")))

# Better map
#create a set of lonxlat pairs of values, one for each element in the Temp_array
grid <- expand.grid(lon=longitude, lat=latitude)
# set colorbar
cutpts <- c(12,13,14,15,16,17,18,19,20)
# plot
levelplot(T_slice ~ lon * lat,
          data=grid, region=TRUE,
          pretty=T, at=cutpts, cuts=9,
          col.regions=(rev(brewer.pal(9,"RdBu"))), contour=0,
          xlab = "Longitude", ylab = "Latitude",
          main = "Sea Water Potential Temperature (°C)"
)

