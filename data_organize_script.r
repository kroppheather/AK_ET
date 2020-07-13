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

datT <-

#look at data
plot(datF$DY,datF$LH, type="b",pch=19)

head(datesN)
    plot(datF$DD[datF$yr == 2018 ], datF$LH[datF$yr == 2018 ],
     type="b", xlim=c(180,220), pch=19)

         plot(datF$DD[datF$yr == 2018 ], datF$LH[datF$yr == 2018 ],
     type="b", xlim=c(180,190), pch=19)

  plot(datF$DD[datF$yr == 2019 ], datF$LH[datF$yr == 2019 ],
    type="b", pch=19) 

    hist(datF$LH)

#