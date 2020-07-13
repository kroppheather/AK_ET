#starting script to organize data download
# Install rhdf5 package (only need to run if not already installed)
#install.packages("BiocManager")
#BiocManager::install("rhdf5")
#install.packages("neonUtilities")
# Call the R HDF5 Library
library(rhdf5)
#neon library
library(neonUtilities)
options(stringsAsFactors=F)
library(raster)

dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"

###June 2018

zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2018-06", enddate="2018-06",
              savepath=paste0(dirD,"/06_2018"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/06_2018/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/06_2018.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2018/",strsplit(foot[[i]]@data@names,"\\.")[[1]][18],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/06_2018/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/06_2018.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/06_2018_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())

#####July 2018 ######


dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2018-07", enddate="2018-07",
              savepath=paste0(dirD,"/07_2018"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/07_2018/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/07_2018.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2018/",strsplit(foot[[i]]@data@names,"\\.")[[1]][18],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/07_2018/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/07_2018.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/07_2018_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())


#####August 2018 ######


dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2018-08", enddate="2018-08",
              savepath=paste0(dirD,"/08_2018"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/08_2018/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/08_2018.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2018/",strsplit(foot[[i]]@data@names,"\\.")[[1]][18],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/08_2018/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/08_2018.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/08_2018_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())


#####June 2019 ######


dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2019-06", enddate="2019-06",
              savepath=paste0(dirD,"/06_2019"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/06_2019/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/06_2019.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2019/",strsplit(foot[[i]]@data@names,"\\.")[[1]][19],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/06_2019/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/06_2019.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/06_2019_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())

#####July 2020 ######


dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2019-07", enddate="2019-07",
              savepath=paste0(dirD,"/07_2019"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/07_2019/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/07_2019.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2019/",strsplit(foot[[i]]@data@names,"\\.")[[1]][19],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/07_2019/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/07_2019.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/07_2019_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())

#####August 2020 ######


dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
            site=c("HEAL"), 
             startdate="2019-08", enddate="2019-08",
              savepath=paste0(dirD,"/08_2019"), 
              check.size=F)

#extract footpring
foot <-   footRaster(filepath=paste0(dirD,"/08_2019/filesToStack00200"))      
#save
writeRaster(foot[[1]],paste0(dirD,"/rasters/summary/08_2019.tif"), format = "GTiff")

for(i in 2:dim(foot)[3]){
  writeRaster(foot[[i]],paste0(dirD,"/rasters/2019/",strsplit(foot[[i]]@data@names,"\\.")[[1]][19],".tif"), format = "GTiff")

 }

 

flux <- stackEddy(filepath=paste0(dirD,"/08_2019/filesToStack00200"),
                 level="dp04")


write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/data/08_2019.csv", sep=",", row.names=FALSE)

write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/fluxes/variables/08_2019_Variables.csv", sep=",", row.names=FALSE)

rm(list=ls())

###download met

dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"

rad <- loadByProduct("DP1.00023.001", site="HEAL", avg=30,
                    startdate="2018-01", enddate="2019-12",
                    package="basic", check.size=F)

write.table(rad$SLRNR[rad$SLRNR$verticalPosition == "040",], paste0(dirD,"/met/rad/net_rad.csv"),sep=",",row.names=FALSE)
write.table(rad$variables_0023, paste0(dirD,"/met/rad/net_rad_variables.csv"),sep=",",row.names=FALSE)


air <- loadByProduct("DP1.00003.001", site="HEAL", avg=30,
                    startdate="2018-01", enddate="2019-12",
                    package="basic", check.size=F)

write.table(air$TAAT_30min, paste0(dirD,"/met/temp/air_temp.csv"),sep=",",row.names=FALSE)
write.table(air$variables_00003, paste0(dirD,"/met/temp/air_temp._variables.csv"),sep=",",row.names=FALSE)

surf <- loadByProduct("DP1.00005.001", site="HEAL", avg=30,
                    startdate="2018-01", enddate="2019-12",
                    package="basic", check.size=F)

write.table(surf$IRBT_30_minute[surf$IRBT_30_minute$horizontalPosition == "000" & surf$IRBT_30_minute$verticalPosition == "020",], paste0(dirD,"/met/temp/bio_surf_temp.csv"),sep=",",row.names=FALSE)
write.table(surf$variables_00005, paste0(dirD,"/met/temp/bio_surf_temp_variables.csv"),sep=",",row.names=FALSE)



precip <- loadByProduct("DP1.00006.001", site="HEAL", avg=30,
                    startdate="2018-01", enddate="2019-12",
                    package="basic", check.size=F)

write.table(precip$SECPRE_30min, paste0(dirD,"/met/precip/precip.csv"),sep=",",row.names=FALSE)
write.table(precip$variables_00006, paste0(dirD,"/met/precip/precip_variables.csv"),sep=",",row.names=FALSE)


rh <- loadByProduct("DP1.00098.001", site="HEAL", avg=30,
                    startdate="2018-01", enddate="2019-12",
                    package="basic", check.size=F)

write.table(rh$RH_30min[rh$RH_30min$verticalPosition == "040",], paste0(dirD,"/met/temp/rel_hum.csv"),sep=",",row.names=FALSE)
write.table(rh$variables_00098, paste0(dirD,"/met/temp/rel_hum_variables.csv"),sep=",",row.names=FALSE)