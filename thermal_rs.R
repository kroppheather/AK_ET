library(raster)
library(rgdal)


inDir <- "/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/odm_ortho/07_04/"
thermal <- raster("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/odm_ortho/07_04/georefT_07_04.tif")
plot(thermal)

#read in shapefilse
shrubs <- readOGR(paste0(inDir,"shrubs.shp"))
shrubsp <- spTransform(shrubs, thermal@crs)
plot(shrubsp,add=TRUE)

trees <- readOGR(paste0(inDir,"trees.shp"))
treesp <- spTransform(trees, thermal@crs)

shadows <- readOGR(paste0(inDir,"shadows.shp"))
shadowsp <- spTransform(shadows, thermal@crs)

lichens <- readOGR(paste0(inDir,"lichen.shp"))
lichensp<- spTransform(lichens, thermal@crs)

shortShrubs <- readOGR(paste0(inDir,"shortShrub.shp"))
shortShrubsp<- spTransform(shortShrubs, thermal@crs)

shrubsR <- rasterize(shrubsp,thermal)
treesR <-  rasterize(treesp,thermal)
shadowR <- rasterize(shadowsp,thermal)
lichenR <- rasterize(lichensp,thermal)
shortShrubR <- rasterize(shortShrubsp,thermal)
plot(shrubsR)

tempRS <- data.frame(temp = c(
                          mean(zonal(thermal,shrubsR)[,2]),
                          mean(zonal(thermal,treesR)[,2]),
                          mean(zonal(thermal,shadowR)[,2]),
                          mean(zonal(thermal,lichenR)[,2]),
                          mean(zonal(thermal,shortShrubR)[,2])),
                     type = c("tall shrub", "spruce","shadow","lichen","short shrub"))


##################################
##### other data             #####
##################################
#look at leaf temp
leafT <- read.csv("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/thermal_canopy/healy/leaf_temp/subset_out/leaf_temp_ir.csv")
leafT$decDay <- leafT$doy + (leafT$start_time/24)

#calculate averages of plant leaf temperatures

leafA <- aggregate(leafT$average, by=list(leafT$species1,
                                          leafT$doy,
                                          leafT$start_time),
                   FUN="mean")
leafSD <- aggregate(leafT$average, by=list(leafT$species1,
                                           leafT$doy,
                                           leafT$start_time),
                    FUN="sd")
colnames(leafA) <- c("type", "doy","hour","averageT")

leafA$decDay <- leafA$doy + (leafA$hour/24)
leafA$sdT <- leafSD$x

BetT <- leafA[leafA$type == "betula",]
SalT <- leafA[leafA$type == "salix",]
SprT <- leafA[leafA$type == "spruce",]
LicT <- leafA[leafA$type == "lichen",]

leafA[leafA$doy == 185,]


tempRS
