#########################################################
###### Reads in neon data downloads                ######
###### and organizes into a dataframe called neonH ######
###### with the following key variables:           ######
###### doy, yr, hour in local time                 ######
###### LH: latent heat in W m-2                    ######
###### SH: Sensible heat in W m-2                  ######
###### inSH: incoming shortwave in  W m-2          ######
###### outSH: outgoing showrtwave in W m-2         ######      
###### inLW: incoming longwave in W m-2            ######
###### outLW: outgoing longwave in W m-2           ######
###### airT: air temperatue in degrees C           ######
###### bioTemp: surface temperature in degrees C   ######
###### RH: relative humidity in %                  ######
###### RH.temp: air temp of humidiy sensor         ######
###### e.sat: saturated water vapor in kpa         ######
###### D: vpd in kpa                               ######
###### ET: calculated from from LH                 ######
######     using ReddyProc in mmol m-2 s-1         ######
#########################################################

#organize and work flux data
library(dplyr)
library(lubridate)
library(REddyProc)


#home directory
dirD <- "/Users/hkropp/Google Drive/research/projects/Healy_ET/healy_flux"

fluxFile <-list.files(paste0(dirD, "/fluxes/data"), full.names=TRUE)


flux <- read.csv(fluxFile[1])

for(i in 2:length(fluxFile)){
  flux <- rbind(flux, read.csv(fluxFile[i]))

}


#start a new data frame
datF <- data.frame(timeStart = flux$timeBgn,
                    LH = flux$data.fluxH2o.nsae.flux,
                    SH = flux$data.fluxTemp.nsae.flux)

datF$timeStartC <- as.character(ymd_hms(datF$timeStart))
#organize
datF <- datF[order(datF$timeStart),]

# set up quantile filter

LHO <- quantile(datF$LH, prob=c(.01,.05,.25,.5,.75,.95,0.99), na.rm=TRUE)

#filter out outliers
datF$LH[datF$LH <= LHO[1] | datF$LH >= LHO[7]] <- NA

#read in other met data

datNR <- read.csv(paste0(dirD,"/met/rad/net_rad.csv"))
datT <- read.csv(paste0(dirD,"/met/temp/air_temp.csv"))
datBT <- read.csv(paste0(dirD,"/met/temp/bio_surf_temp.csv"))
datRH <- read.csv(paste0(dirD,"/met/temp/rel_hum.csv"))
datP <- read.csv(paste0(dirD,"/met/precip/precip.csv"))
#organize dates
datNRs <- data.frame(timeStartN= datNR$startDateTime,
                    inSW = datNR$inSWMean,
                    outSW = datNR$outSWMean,
                    inLW = datNR$inLWMean,
                    outLW = datNR$outLWMean)
#air temp
datTs <- data.frame(timeStartT = datT$startDateTime,
                    airT = datT$tempTripleMean)

#biological surface temperature
datBs <- data.frame(timeStartB = datBT$startDateTime,
                    bioTemp = datBT$bioTempMean)


#humidity and vpd

datRs <- data.frame(timeStartR = datRH$startDateTime,
                    RH = datRH$RHMean,
                    RH.temp = datRH$tempRHMean,
                    e.sat = 0.611*exp((17.502*datRH$tempRHMean)/(datRH$tempRHMean+240.97)))
datRs$D <- datRs$e.sat - ((datRs$RH/100)*datRs$e.sat)



#join met data with fluxes


neonHt1 <- left_join(datTs,datNRs, by=c("timeStartT" = "timeStartN"))
neonHt2 <- left_join(neonHt1,datBs, by=c("timeStartT" = "timeStartB"))
neonHt3 <- left_join(neonHt2,datRs, by=c("timeStartT" = "timeStartR"))


neonH <- left_join(neonHt3,datF, by=c("timeStartT" = "timeStartC"))



neonH$formatD <- as.POSIXct(neonH$timeStartT, 
                    format="%Y-%m-%d %H:%M:%S", 
                    tz="GMT")

#convert to local time
neonH$timeLocal <- with_tz(neonH$formatD, "US/Alaska")                    
#calculate useful date metrics
neonH$yr <- year(neonH$timeLocal)
neonH$doy <- yday(neonH$timeLocal)
neonH$hour <- hour(neonH$timeLocal) + (minute(neonH$timeLocal)/60)
#calculate ET in mmol m-2 s-1
neonH$ET <- fCalcETfromLE(neonH$LH, neonH$airT)

neonH$decDay <- neonH$doy + (neonH$hour/24)
neonH$decYear <- neonH$yr + (neonH$decDay/365)

#clear all variables except for T and gc outptut
rm(list=setdiff(ls(), c("neonH")))