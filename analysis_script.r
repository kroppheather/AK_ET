#reads in neonH
source("/Users/hkropp/Documents/GitHub/AK_ET/data_organize_script.r")

#set plot dir
plotDir <- "/Users/hkropp/Google Drive/research/Healy_ET/figures"

#add in net radiation
neonH$netR <- (neonH$inSW-neonH$outSW) + (neonH$inLW - neonH$outSW)


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

#############plot of time series panels ################
wd <- 15
hd <- 7

#xlimits
xl1 <- 152
xh1 <- 243
yl1 <- 0
yh1 <- 30
yl2 <- 0
yh2 <- 5
yl3 <- 0
yh3 <- 1000

png(paste0(plotDir,"/hh_time_summer.png"),
 width = 32, height = 24, units = "cm", res=200 )
  layout(matrix(seq(1,6), ncol=2),
       width=c(lcm(wd),lcm(wd)),
       height=rep(lcm(hd),3))
  #plot 1: temps 2018     
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl1, yh1), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$bioTemp[neonH$yr == 2018],
        pch=19, type="b")
  #plot 2: temps 2019
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl1, yh1), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$bioTemp[neonH$yr == 2019],
        pch=19, type="b")
#plot 3: ET 2018
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl2, yh2), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$ET[neonH$yr == 2018],
        pch=19, type="b")  
#plot 4: ET 2019
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl2, yh2), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$ET[neonH$yr == 2019],
        pch=19, type="b")  

#plot 5: net R 2018
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl3, yh3), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$netR[neonH$yr == 2018],
        pch=19, type="b")

 #plot 6: net R 2019
  par(mai=c(0.5,0.5,0.5,0.5))
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl3, yh3), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$netR[neonH$yr == 2019],
        pch=19, type="b")       
dev.off()
#############plot of individual day ################

  plot(neonH$decDay[neonH$yr == 2018 & neonH$doy == 185],neonH$bioTemp[neonH$yr == 2018 & neonH$doy == 185], 
   type="b", pch=19, col="tomato3")

  points(neonH$decDay[neonH$yr == 2018 & neonH$doy == 185],neonH$airT[neonH$yr == 2018 & neonH$doy == 185],
  col="royalblue4", type="b", pch=19)  

  points(leafA$decDay,leafA$averageT,
  col="darkgreen",  pch=19)  
