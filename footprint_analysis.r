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


plotRGB(rgbH, ext=c(390600,391455,708400,7088000)))
plotRGB(rgbH2, add=TRUE)
plotRGB(rgbH3, add=TRUE)
plot(f.test, add=TRUE, alpha=0.5)

plotRGB(rgbH3)

rgbH3@extent
plotRGB(rgbH2)
plotRGB(thermal, add=TRUE)