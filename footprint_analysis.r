library(raster)

rgbH <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/AK_uas_mapping/Neon_map.tif")
rgbH2 <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/maps/healy_7_07_18.tif")
rgbH3 <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/maps/healy_flight_1.tif")

str(rgbH)

#read in test footprint
f.test <- raster("/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/rasters/2018/20180704T120000Z.tif")


plotRGB(rgbH)
plot(f.test, add=TRUE, alpha=0.5)



thermal <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_orthomosaic/7_07_c1_georeferenced.tif")



plotRGB(rgbH, ext=c(390600,391455,708400,7088000))
plotRGB(rgbH2, add=TRUE)
plotRGB(rgbH3, add=TRUE)
plot(f.test, add=TRUE, alpha=0.5)

plotRGB(rgbH3)

rgbH3@extent
plotRGB(rgbH2)
plotRGB(thermal, add=TRUE)


#read in sentinal data

Dirs <- c(
    "/Users/hkropp/Google Drive/research/Healy_ET/S2A/S2A_MSIL2A_20190819T214531_N0213_R129_T06VUR_20190820T020456.SAFE/GRANULE/L2A_T06VUR_A021719_20190819T214532/IMG_DATA/R10m",
    "/Users/hkropp/Google Drive/research/Healy_ET/S2A/S2A_MSIL2A_20190819T214531_N0213_R129_T05WPM_20190820T020456.SAFE/GRANULE/L2A_T05WPM_A021719_20190819T214532/IMG_DATA/R10m",
    "/Users/hkropp/Google Drive/research/Healy_ET/S2A/S2B_MSIL2A_20190705T214539_N0212_R129_T05VPL_20190706T000242.SAFE/GRANULE/L2A_T05VPL_A012167_20190705T214538/IMG_DATA/R10m",
    "/Users/hkropp/Google Drive/research/Healy_ET/S2A/S2B_MSIL2A_20190705T214539_N0212_R129_T05WPM_20190706T000242.SAFE/GRANULE/L2A_T05WPM_A012167_20190705T214538/IMG_DATA/R10m")

FilesR <- list()
for(i in 1:4){

    FilesR[[i]]<- list.files(Dirs[i])
}

#read in 
S2AB1 <- raster(paste0(Dirs[1],"/",FilesR[[1]][2]))