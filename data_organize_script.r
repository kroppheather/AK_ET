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
dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"

fluxFile <-list.files(paste0(dirD, "/fluxes/data"), full.names=TRUE)


flux <- read.csv(fluxFile[1])

for(i in 2:length(fluxFile)){
  flux <- rbind(flux, read.csv(fluxFile[i]))

}


#start a new data frame
datF <- data.frame(timeStart = flux$timeBgn,
                    timeEnd = flux$timeEnd,
                    LH = flux$data.fluxH2o.nsae.flux,
                    SH = flux$data.fluxTemp.nsae.flux)
#convert dates
datF$dates <- ymd_hms(datF$timeStart)
#convert to local time
datF$timeE <- with_tz(datF$dates, "US/Alaska")
#calculate useful date metrics
datF$yr <- year(datF$timeE)
datF$doy <- yday(datF$timeE)
datF$hour <- hour(datF$timeE) + (minute(datF$timeE)/60)
datF$DD <- datF$doy + (datF$hour/24)
datF$DY <- ifelse(leap_year(datF$timeE), 
                    datF$yr + ((datF$doy-1)/366),
                    datF$yr + ((datF$doy-1)/365))
datF$month <- month(datF$timeE)

#organize
datF <- datF[order(datF$timeE),]
###############################
###filter out extreme values###
###############################
LHO <- quantile(datF$LH, prob=c(.01,.05,.25,.5,.75,.95,0.99), na.rm=TRUE)

#filter out outliers
datF$LH[datF$LH <= LHO[1] | datF$LH >= LHO[7]] <- NA

#read in other met data

datNR <- read.csv(paste0(dirD,"/met/rad/net_rad.csv"))
datT <- read.csv(paste0(dirD,"/met/temp/air_temp.csv"))
datBT <- read.csv(paste0(dirD,"/met/temp/bio_surf_temp.csv"))
datRH <- read.csv(paste0(dirD,"/met/temp/rel_hum.csv"))
#organize dates
#convert dates
datNRs <- data.frame(timeStartN= datNR$startDateTime,
                    inSW = datNR$inSWMean,
                    outSW = datNR$outSWMean,
                    inLW = datNR$inLWMean,
                    outLW = datNR$outLWMean)
datesN <- ymd_hms(datNRs$timeStartN)
#convert to local time
datNRs$timeN <- with_tz(datesN, "US/Alaska")
#calculate useful date metrics
datNRs$yr <- year(datNRs$timeN)
datNRs$doy <- yday(datNRs$timeN)
datNRs$hour <- hour(datNRs$timeN) + (minute(datNRs$timeN)/60)

datTs <- data.frame(timeStartT = datT$startDateTime,
                    airT = datT$tempTripleMean)
datesS <- ymd_hms(datTs$timeStartT)
#convert to local time
datTs$timeS <- with_tz(datesS, "US/Alaska")
#calculate useful date metrics
datTs$yr <- year(datTs$timeS)
datTs$doy <- yday(datTs$timeS)
datTs$hour <- hour(datTs$timeS) + (minute(datTs$timeS)/60)

#biological surface temperature
datBs <- data.frame(timeStartB = datBT$startDateTime,
                    bioTemp = datBT$bioTempMean)
datesB <- ymd_hms(datBs$timeStartB)
#convert to local time
datBs$timeB <- with_tz(datesB, "US/Alaska")
#calculate useful date metrics
datBs$yr <- year(datBs$timeB)
datBs$doy <- yday(datBs$timeB)
datBs$hour <- hour(datBs$timeB) + (minute(datBs$timeB)/60)

#humidity and vpd


datRs <- data.frame(timeStartR = datRH$startDateTime,
                    RH = datRH$RHMean,
                    RH.temp = datRH$tempRHMean,
                    e.sat = 0.611*exp((17.502*datRH$tempRHMean)/(datRH$tempRHMean+240.97)))
datRs$D <- datRs$e.sat - ((datRs$RH/100)*datRs$e.sat)

datesR <- ymd_hms(datRs$timeStartR)
#convert to local time
datRs$timeR <- with_tz(datesR, "US/Alaska")
#calculate useful date metrics
datRs$yr <- year(datRs$timeR)
datRs$doy <- yday(datRs$timeR)
datRs$hour <- hour(datRs$timeR) + (minute(datRs$timeR)/60)

#join met data with fluxes
#air temp is complete
datTs$decDay <- datTs$doy + (datTs$hour/24)
datTs$decYear <- datTs$yr + (datTs$decDay/365)

datNRs$decDay <- datNRs$doy + (datNRs$hour/24)
datNRs$decYear <- datNRs$yr + (datNRs$decDay/365)

datT2 <- data.frame(time= datTs$timeS,
                    airT = datTs$airT)
 datNR2 <- data.frame(time = datNRs$timeN,
                      inSW = datNRs$inSW)                   
test <- left_join(datT2, datNR2, by=c("time"))
test2 <- merge(datT2, datNR2, by=c("year","doy","hour"))
neonHt1 <- merge(datTs,datNRs, by=c("decYear"))


neonHt2 <- left_join(neonHt1,datF, by=c("yr","doy","hour"))
neonHt3 <- left_join(neonHt2,datBs, by=c("yr","doy","hour"))
neonH <- left_join(neonHt3,datRs, by=c("yr","doy","hour"))
#calculate ET in mmol m-2 s-1
neonH$ET <- fCalcETfromLE(neonH$LH, neonH$airT)

test <- unique(data.frame(doy=neonH$doy, yr=neonH$yr, hour=neonH$hour))

neonH$decDay <- neonH$doy + (neonH$hour/24)
neonH$decYear <- neonH$yr + (neonH$decDay/365)

#clear all variables except for T and gc outptut
rm(list=setdiff(ls(), c("neonH")))