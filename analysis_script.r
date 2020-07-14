#reads in neonH
source("/Users/hkropp/Documents/GitHub/AK_ET/data_organize_script.r")

#look at leaf temp
leafT <- read.csv("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/thermal_canopy/healy/leaf_temp/subset_out/leaf_temp_ir.csv")
leafT$decDay <- leafT$doy + (leafT$start_time/24)

plot(neonH$decDay[neonH$yr == 2018],neonH$bioTemp[neonH$yr == 2018], 
    xlim=c(178,195), type="b", ylim=c(0,30), pch=19, col="tomato3")

  points(neonH$decDay[neonH$yr == 2018],neonH$airT[neonH$yr == 2018],
  col="royalblue4", type="b", pch=19)  

  points(leafT$decDay,leafT$average,
  col="darkgreen",  pch=19)  