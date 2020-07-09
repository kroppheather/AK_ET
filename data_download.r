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

#zipsByProduct(dpID="DP4.00200.001", package="expanded", 
 #             site=c("HEAL"), 
  #            startdate="2017-01", enddate="2017-12",
   #           savepath=paste0(dirD,"/2017"), 
    #          check.size=F)

#zipsByProduct(dpID="DP4.00200.001", package="expanded", 
#              site=c("HEAL"), 
#              startdate="2018-08", enddate="2018-09",
#              savepath=paste0(dirD,"/summer2018"), 
#              check.size=F)

#zipsByProduct(dpID="DP4.00200.001", package="expanded", 
 #             site=c("HEAL"), 
  #            startdate="2019-01", enddate="2019-12",
   #           savepath=paste0(dirD,"/2019"), 
    #          check.size=F)

##flux <- stackEddy(filepath=paste0(dirD,"/filesToStack00200"),
#                 level="dp04")

  foot <-   footRaster(filepath=paste0(dirD,"/summer2018/filesToStack00200"))        
str(foot[[1]])
str(foot[[2]])
str(foot[[3]])
foot[[1]]@data@names

foot[[2]]@data@names
#plot(as.Date(flux$HEAL$timeEnd), flux$HEAL$data.fluxH2o.nsae.flux)

#tail(flux$HEAL)

#flux$HEAL <- cbind(timeB, flux$HEAL)
#write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/healyFluxes.csv", sep=",", row.names=FALSE)

#write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/healyFluxesVariables.csv", sep=",", row.names=FALSE)

