library(raster)
library(rgdal)

#set footprint directory
#start with 2018 only
diR18 <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/rasters/2018"
#directory for output
diRout <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/footprint"
#directory for 2019
diR19 <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/rasters/2019"
#rgb for reference
rgbH <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/AK_uas_mapping/Neon_map.tif")
#get file names
rast18 <- list.files(diR18)
#raster for 19
rast19 <- list.files(diR19)
#approximate vegetation cover
vege <- readOGR("/Users/hkropp/Google Drive/research/Healy_ET/QGIS/vege_tall.shp")



#initiate variables
footF <- raster(paste0(diR18,"/",rast18[1]))
footInfo <- data.frame(year = as.numeric(substr(rast18[1],1,4)),
                       month = as.numeric(substr(rast18[1],5,6)),
                       day = as.numeric(substr(rast18[1],7,8)),
                       hr = as.numeric(substr(rast18[1],10,11)),
                       min = as.numeric(substr(rast18[1],12,13)),
                       zone = "UTC")
#get vegetation as raster
vegeP <- spTransform(vege,footF@crs)
vegeR <- rasterize(vegeP,footF, field=1)

#raster math
vegeF <- footF * vegeR

#get percent cover tall vegetation
footInfo$tallC <- sum(getValues(vegeF), na.rm=TRUE)
footTemp <- data.frame()
for(i in 2: length(rast18)){
  footF <- raster(paste0(diR18,"/",rast18[i]))
  footTemp<- data.frame(year = as.numeric(substr(rast18[i],1,4)),
                         month = as.numeric(substr(rast18[i],5,6)),
                         day = as.numeric(substr(rast18[i],7,8)),
                         hr = as.numeric(substr(rast18[i],10,11)),
                         min = as.numeric(substr(rast18[i],12,13)),
                         zone = "UTC")
  #get vegetation as raster
  vegeR <- rasterize(vegeP,footF, field=1)
  
  #raster math
  vegeF <- footF * vegeR
  
  #get percent cover tall vegetation
  footTemp$tallC <- sum(getValues(vegeF), na.rm=TRUE)
  footInfo <- rbind(footInfo,footTemp)
}


#write.table(footInfo, paste0(diRout,"/vege_2018.csv"),sep=",", row.names = FALSE)


#2019


#initiate variables
footF <- raster(paste0(diR19,"/",rast19[1]))
footInfo <- data.frame(year = as.numeric(substr(rast19[1],1,4)),
                       month = as.numeric(substr(rast19[1],5,6)),
                       day = as.numeric(substr(rast19[1],7,8)),
                       hr = as.numeric(substr(rast19[1],10,11)),
                       min = as.numeric(substr(rast19[1],12,13)),
                       zone = "UTC")
#get vegetation as raster
vegeP <- spTransform(vege,footF@crs)
vegeR <- rasterize(vegeP,footF, field=1)

#raster math
vegeF <- footF * vegeR

#get percent cover tall vegetation
footInfo$tallC <- sum(getValues(vegeF), na.rm=TRUE)
footTemp <- data.frame()
for(i in 2: length(rast19)){
  footF <- raster(paste0(diR19,"/",rast19[i]))
  footTemp<- data.frame(year = as.numeric(substr(rast19[i],1,4)),
                        month = as.numeric(substr(rast19[i],5,6)),
                        day = as.numeric(substr(rast19[i],7,8)),
                        hr = as.numeric(substr(rast19[i],10,11)),
                        min = as.numeric(substr(rast19[i],12,13)),
                        zone = "UTC")
  #get vegetation as raster
  vegeR <- rasterize(vegeP,footF, field=1)
  
  #raster math
  vegeF <- footF * vegeR
  
  #get percent cover tall vegetation
  footTemp$tallC <- sum(getValues(vegeF), na.rm=TRUE)
  footInfo <- rbind(footInfo,footTemp)
}

