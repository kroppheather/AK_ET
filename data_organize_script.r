#organize and work flux data
library(dplyr)
library(lubridate)


#home directory
dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/healy_flux"

flux <- read.csv(paste0(dirD, "/healyFluxes.csv"))

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

plot(datF$DD[datF$yr == 2018 ], datF$LH[datF$yr == 2018 ],
    xlim = c(182, 212), type="b", pch=19)

    plot(datF$DD[datF$yr == 2018 ], datF$SH[datF$yr == 2018 ],
     type="b", pch=19)

  plot(datF$DD[datF$yr == 2019 ], datF$LH[datF$yr == 2019 ],
    type="b", pch=19) 

    hist(datF$LH)
LHO <- quantile(datF$LH, prob=c(.01,.05,.25,.5,.75,.95,0.99), na.rm=TRUE)
#filter out outliers
datLf <- datF[datF$LH >= LHO[1] & datF$LH <= LHO[7],]
#look at summer months
#june
plot(datLf$DD[datLf$month == 6], datLf$LH[datLf$month == 6], pch=19, type="b", col="tomato3")

points(datLf$DD[datLf$month == 6 & datLf$yr == 2018], datLf$LH[datLf$month == 6 & datLf$yr == 2018],pch=19, type="b", col="darkgoldenrod4")

points(datLf$DD[datLf$month == 6 & datLf$yr == 2019], datLf$LH[datLf$month == 6 & datLf$yr == 2019], pch=19, type="b", col="royalblue3")

#july
plot(datLf$DD[datLf$month == 7], datLf$LH[datLf$month == 7], pch=19, type="b", col="tomato3")

points(datLf$DD[datLf$month == 7 & datLf$yr == 2018], datLf$LH[datLf$month == 7 & datLf$yr == 2018],pch=19, type="b", col="darkgoldenrod4")

points(datLf$DD[datLf$month == 7 & datLf$yr == 2019], datLf$LH[datLf$month == 7 & datLf$yr == 2019], pch=19, type="b", col="royalblue3")

#august
plot(datLf$DD[datLf$month == 8], datLf$LH[datLf$month == 8], pch=19, type="b", col="tomato3")

points(datLf$DD[datLf$month == 8 & datLf$yr == 2018], datLf$LH[datLf$month == 8 & datLf$yr == 2018],pch=19, type="b", col="darkgoldenrod4")

points(datLf$DD[datLf$month == 8 & datLf$yr == 2019], datLf$LH[datLf$month == 8 & datLf$yr == 2019], pch=19, type="b", col="royalblue3")



names(flux)