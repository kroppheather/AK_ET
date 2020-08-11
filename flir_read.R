library(raster)
library(dplyr)
key <- read.csv("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_out/tiff/7_04_temperature_key.csv")


ortho <- raster("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/odm_ortho/07_04/odm_ortho2_geo2.tif")
plot(ortho)



key$mid <- key$startT + ((key$endT - key$startT)/2)


orthoV <- data.frame(DN = getValues(ortho))
othoA <- left_join(orthoV,key, by="DN")

orthoT <- setValues(ortho,othoA$mid)
plot(orthoT)

writeRaster(orthoT, "/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/odm_ortho/07_04/georefT_07_04.tif",overwrite=TRUE)
