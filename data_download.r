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

dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"

#zipsByProduct(dpID="DP4.00200.001", package="expanded", 
#              site=c("HEAL"), 
#              startdate="2017-01", enddate="2020-05",
#              savepath=dirD, 
#              check.size=F)


##flux <- stackEddy(filepath=paste0(dirD,"/filesToStack00200"),
#                 level="dp04")

  foot <-   footRaster(filepath=paste0(dirD,"/filesToStack00200"))        

#plot(as.Date(flux$HEAL$timeEnd), flux$HEAL$data.fluxH2o.nsae.flux)

#tail(flux$HEAL)
#timeB <- as.POSIXct(flux$HEAL$timeEnd, 
                    format="%Y-%m-%dT%H:%M:%S", 
                    tz="GMT")
#flux$HEAL <- cbind(timeB, flux$HEAL)
#write.table(flux$HEAL,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/healyFluxes.csv", sep=",", row.names=FALSE)

#write.table(flux$variables,"/Users/hkropp/Google Drive/research/Healy_ET/healy_flux/healyFluxesVariables.csv", sep=",", row.names=FALSE)

