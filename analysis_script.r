#reads in neonH
source("/Users/hkropp/Documents/GitHub/AK_ET/data_organize_script.r")

#set plot dir
plotDir <- "/Users/hkropp/Google Drive/research/Healy_ET/figures"

#add in net radiation
neonH$netR <- (neonH$inSW-neonH$outSW) + (neonH$inLW - neonH$outSW)
#calculate difference in temp
neonH$tempDiff <- neonH$bioTemp - neonH$airT

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

#############plot of time series panels ################
wd <- 15
hd <- 7

#limits
xl1 <- 182
xh1 <- 212
yl1 <- 0
yh1 <- 37
yl2 <- 0
yh2 <- 5
yl3 <- 0
yh3 <- 1200
#axis sequences
xs <- seq(182,212, by=5)
ys1 <- seq(0,30, by=5)
ys2 <- seq(0,5, by=1)
ys3 <- seq(0, 1000, by=200)
#line width
llw <- 2
#main color
col1 <- rgb(0.25,0.25,0.25)
col2 <- "tomato3"
spC <- "springgreen3"
saC <- "deepskyblue3"
baC <- "darkgoldenrod3"
#tick width
tww <- 2
#axis label size
axc <- 1.5
#x axis label line
alx <- 2
#plot margins
pm <- c(0.5,0,0,0.5)
#legend size
lgc <- 2
#label size
lxc <- 1.75
#y label line
yll1 <- 6
yll2 <- 1
yll3 <- 5
#size of leaf temp points
lpc <- 1

png(paste0(plotDir,"/hh_time_summer.png"),
 width = 37, height = 25, units = "cm", res=200 )
  layout(matrix(seq(1,6), ncol=2, byrow = TRUE),
       width=c(lcm(wd),lcm(wd)),
       height=rep(lcm(hd),3))
  #plot 1: temps 2018     
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl1, yh1), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$bioTemp[neonH$yr == 2018],
        type="l", lw=llw, col=col1)
  points(neonH$decDay[neonH$yr == 2018],
         neonH$airT[neonH$yr == 2018],
         type="l", col=col2, lw=llw)
  
  points(SprT$decDay, SprT$averageT, pch=19,
         col=spC, cex=lpc)
  points(SalT$decDay, SalT$averageT, pch=19,
         col=saC, cex=lpc)
  points(BetT$decDay, BetT$averageT, pch=19,
         col=baC, cex=lpc)
  legend("topright", c("Spruce", "Salix", "Betula"),
         col=c(spC,saC,baC), bty="n", pch=19,cex=lpc)
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  axis(2, ys1, rep(" ", length(ys1)),lwd.ticks=tww)
  mtext(ys1, at=ys1, side=2, cex=axc, line=alx, las=2)

  mtext(expression(paste("Temperature (",degree,"C)")),
        side=2, line=yll1 , cex=lxc)
  mtext("July 2018",
        side=3, line=yll2 , cex=lxc)
  #plot 2: temps 2019
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl1, yh1), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$bioTemp[neonH$yr == 2019],
        type="l", lw=2, col=col1)
  points(neonH$decDay[neonH$yr == 2019],
         neonH$airT[neonH$yr == 2019],
         type="l", col=col2, lw=llw)
  legend("topright", c("surface", "air"),
         col=c(col1,col2), bty="n", lwd=llw, cex=lgc)
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  axis(2, ys1, rep(" ", length(ys1)),lwd.ticks=tww)
  mtext("July 2019",
        side=3, line=yll2 , cex=lxc)
#plot 3: ET 2018
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl2, yh2), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$ET[neonH$yr == 2018],
        type="l", lw=2, col=col1) 
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  axis(2, ys2, rep(" ", length(ys2)),lwd.ticks=tww)
  mtext(ys2, at=ys2, side=2, cex=axc, line=alx, las=2)
  mtext(expression(paste("ET (mmol m"^"-2", "s"^"-1",")")),
        side=2, line=yll1 , cex=lxc)
#plot 4: ET 2019
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl2, yh2), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$ET[neonH$yr == 2019],
        type="l", lw=2, col=col1)  
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  axis(2, ys2, rep(" ", length(ys2)),lwd.ticks=tww)
#plot 5: net R 2018
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl3, yh3), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2018],
        neonH$netR[neonH$yr == 2018],
        type="l", lw=2, col=col1)
  points(neonH$decDay[neonH$yr == 2018],
         neonH$inSW[neonH$yr == 2018],
         type="l", col=col2, lw=llw)
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  mtext(xs, at=xs, side=1, cex=axc, line=alx)
  axis(2, ys3, rep(" ", length(ys3)),lwd.ticks=tww)
  mtext(ys3, at=ys3, side=2, cex=axc, line=alx, las=2)
  mtext(expression(paste("radiation (W m"^"-2",")")),
        side=2, line=yll1 , cex=lxc)
  mtext("Day of year",
        side=1, line=yll3 , cex=lxc)

 #plot 6: net R 2019
  par(mai=pm)
  plot(c(0,1),c(0,1), type = "n", xlim = c(xl1,xh1),
    ylim = c(yl3, yh3), axes = FALSE, xlab = " ", 
    ylab =" ", yaxs = "i", xaxs = "i")
  points(neonH$decDay[neonH$yr == 2019],
        neonH$netR[neonH$yr == 2019],
        type="l", lw=2, col=col1)  
  points(neonH$decDay[neonH$yr == 2019],
         neonH$inSW[neonH$yr == 2019],
         type="l", col=col2, lw=llw)
  axis(1, xs, rep(" ", length(xs)),lwd.ticks=tww)
  mtext(xs, at=xs, side=1, cex=axc, line=alx)
  axis(2, ys3, rep(" ", length(ys3)),lwd.ticks=tww)
  mtext("Day of year",
        side=1, line=yll3 , cex=lxc)
  legend("topright", c("net", "in-SW"),
         col=c(col1,col2), bty="n", lwd=llw, cex=lgc)
  
dev.off()



#############plot of individual day ################

  plot(neonH$decDay[neonH$yr == 2018 & neonH$doy == 185],neonH$bioTemp[neonH$yr == 2018 & neonH$doy == 185], 
   type="b", pch=19, col="tomato3")

  points(neonH$decDay[neonH$yr == 2018 & neonH$doy == 185],neonH$airT[neonH$yr == 2018 & neonH$doy == 185],
  col="royalblue4", type="b", pch=19)  

  points(leafA$decDay,leafA$averageT,
  col="darkgreen",  pch=19)  
