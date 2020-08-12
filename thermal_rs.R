source("/Users/hkropp/Documents/GitHub/AK_ET/data_organize_script.r")

library(raster)
library(rgdal)

#set plot dir
plotDir <- "/Users/hkropp/Google Drive/research/Healy_ET/figures"

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

shrubsR <- rasterize(shrubsp,thermal, field = 1)
treesR <-  rasterize(treesp,thermal, field = 1)
shadowR <- rasterize(shadowsp,thermal, field = 1)
lichenR <- rasterize(lichensp,thermal, field = 1)
shortShrubR <- rasterize(shortShrubsp,thermal, field = 1)
plot(shrubsR)

#all na got converted to zeros 
thermalF <- setValues(thermal,
                      ifelse(getValues(thermal) < 10 ,
                             NA,
                             getValues(thermal)))

tempRS <- data.frame(temp = c(
                         zonal(thermalF,shrubsR)[,2],
                         zonal(thermalF,treesR)[,2],
                          zonal(thermalF,shadowR)[,2],
                          zonal(thermalF,lichenR)[,2],
                         zonal(thermalF,shortShrubR)[,2]),
                     tempSD = c(
                       zonal(thermalF,shrubsR,"sd")[,2],
                       zonal(thermalF,treesR,"sd")[,2],
                       zonal(thermalF,shadowR,"sd")[,2],
                       zonal(thermalF,lichenR,"sd")[,2],
                       zonal(thermalF,shortShrubR,"sd")[,2]),
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

leafA <- leafA[leafA$doy == 185,]


tempRS

neonSub <- neonH[neonH$doy == 185 & neonH$yr == 2018,]

plotT <- data.frame(name = c(tempRS$type[1],
                             leafA$type[1],
                             leafA$type[2],
                             tempRS$type[5],
                             leafA$type[3],
                             tempRS$type[2:4]),
                    type = c("sUAS","leaf","leaf","sUAS","leaf",rep("sUAS",3)),
                    temp = c(tempRS$temp[1],
                             leafA$averageT[1],
                             leafA$averageT[2],
                             tempRS$temp[5],
                             leafA$averageT[3],
                             tempRS$temp[2:4]),
                    tempSD = c(tempRS$tempSD[1],
                              leafA$sdT[1],
                              leafA$sdT[2],
                              tempRS$tempSD[5],
                              leafA$sdT[3],
                              tempRS$tempSD[2:4]),
                    pchi = c(15,19,19,15,19,rep(15,3)),
                    coli = c(rep("darkseagreen3",3),
                             rep("plum3",2),
                             "palegreen4",
                             "grey75",
                             "peachpuff4"))

#crop to focus on smaller measurement area
thermalFc <- crop(thermalF,c(390625,390725,7085200,7085280))
plot(thermalFc)



wd <- 5
hd <- 5
png(paste0(plotDir,"/RS_temp_comp.png"),
    width = 15, height = 11, units = "cm", res=200 )
  layout(matrix(seq(1,2), ncol=2, byrow = TRUE),
       width=c(lcm(wd),lcm(wd)),
       height=lcm(hd))
  par(mai=c(0,0,0,0))
  plot(c(0,1),c(0,1), type = "n", xlim = c(0,24),
       ylim = c(0, 33), axes = FALSE, xlab = " ", 
       ylab =" ", yaxs = "i", xaxs = "i")
  points(12,neonSub$bioTemp[neonSub$hour == 12], pch =15, col="black",cex=0.75)
  points(neonSub$hour,neonSub$bioTemp, type="l", lwd=2, col="grey50")

  axis(2, seq(0,30, by=5), las=2)
  axis(1, c(-10,seq(0,20, by=4),100))
  mtext(expression(paste("Surface temperature (",degree,"C)")),
                line=2.5, side=2)
  mtext("Hour", line=2.5,side=1)
  plot(c(0,1),c(0,1), type = "n", xlim = c(0,10),
       ylim = c(0, 33), axes = FALSE, xlab = " ", 
       ylab =" ", yaxs = "i", xaxs = "i")
  points(seq(1,8), plotT$temp,pch=plotT$pchi,col=paste(plotT$coli))
  arrows(seq(1,8),plotT$temp - plotT$tempSD,
         seq(1,8),plotT$temp + plotT$tempSD,code = 0, lwd=1)
  abline(h = neonSub$bioTemp[neonSub$hour == 12], col="grey50",
         lty=2)
  legend("bottomright", c("sUAS","leaf"), pch=c(0,1),bty="n")
  axis(4, seq(0,30, by=5), las=2)
  axis(1, c(seq(1,8),10), c(plotT$name, " "),las=2)
  mtext("July 04, 2018", side=3, cex=2, outer=TRUE, line=-5)
  mtext(expression(paste("Canopy temperature (",degree,"C)")),
        side=4,line=2.5)
dev.off()


library(BAMMtools)


getJenksBreaks(getValues(thermalFc), 9)
range(getValues(thermalFc), na.rm=TRUE)
breaks <- c(17,19, 20, 21,22,23,24, 25,26,28,31, 33,45)
cols <- c(
  rgb(0,0.34,0.50),
  rgb(0.02,0.47,0.51),
  rgb(0.54,0.72,0.82),
  rgb(0.62,0.75,0.53),
  rgb(0.31,0.73,0.45),
  rgb(0.87,0.83,0.31),
  rgb(0.99,0.82,0.02),
  rgb(0.99,0.69,0.09),
  rgb(0.96,0.52,.31),
  rgb(0.94,0.38,0.52),
  rgb(0.92,0.34,0.34),
  rgb(0.92,0.74,0.8))

mean(getValues(thermalFc),na.rm=TRUE)
  plot(thermalFc, 
       col=cols, breaks=breaks,)
  
  
