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


S42B02 <- raster("/Users/hkropp/Google Drive/research/Healy_ET/S2A/export42/20190705_42_B02.tif")

S42B03 <- raster("/Users/hkropp/Google Drive/research/Healy_ET/S2A/export42/20190705_42_B03.tif")

S42B04 <- raster("/Users/hkropp/Google Drive/research/Healy_ET/S2A/export42/20190705_42_B04.tif")

sSt <- stack(S42B04,S42B03,S42B02)

#write rasters to folder for QGIS
#writeRaster(sSt, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/Sent42.tif",type="GTiff")
#writeRaster(rgbH, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/Healy_drone.tif",type="GTiff")
#writeRaster(f.test, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/footprint1.tif",type="GTiff")

f.test2 <- raster("/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/rasters/2018/20180704T123000Z.tif")
#writeRaster(f.test2, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/footprint1_30.tif",type="GTiff")

f.test3 <- raster("/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/rasters/2018/20180705T123000Z.tif")
#writeRaster(f.test3, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/footprint3.tif",type="GTiff")

#other thermal flight



thermal2 <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_orthomosaic/7_04_ortho.tif")

str(thermal2)

thermal3 <- thermal2
thermal3@extent <- rgbH3@extent


#writeRaster(thermal3, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/thermal_7_04p2.tif",type="GTiff")


#writeRaster(rgbH3, "/Users/hkropp/Google Drive/research/Healy_ET/QGIS/Healyflight_7_04.tif",type="GTiff")

chm <- raster("/Users/hkropp/Google Drive/research/Healy_ET/QGIS/neon_chm_mos.tif")
plot(chm)
hist(getValues(chm), breaks=c(0,0.1,0.5,1,1.5,2,3,10,20),
     ylim=c(0,0.1))
plotRGB(rgbH)
plot(chm, add=TRUE,
     alpha=0.5)


