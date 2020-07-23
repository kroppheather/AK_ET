library(dplyr)
library(raster)

############################################
###  set up directory                    ###
############################################
#get the directory of files to process
imgDIR <- "/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_out/csv"

#directory to create flight photos
outDIR <- "/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_out/tiff"

############################################
###  get list of flight directory        ###
############################################
#list all flight directories
flightDIRt <- list.dirs(imgDIR, full.names=FALSE)

#remove empty quote of parent directory
#each flight directory will at least have digits for the date
flightDIR <- flightDIRt[grepl("\\d",flightDIRt)] 

#make the output directory
for(i in 1:length(flightDIR)){
  
  dir.create(paste0(outDIR,"/",flightDIR[i]))
  
}
test <- brick("/Users/hkropp/Google Drive/research/Healy_ET/alaska_2018/flir_orthomosaic/7_04_ortho.tif")
plot(test[[1]])
plot(test[[2]])
############################################
###  read in csv files of data           ###
###  and make a tiff                     ###
############################################
#get a list of the files in each directory
flightFiles <- list()
for(i in 1:length(flightDIR)){
  flightFiles[[i]] <- list.files(paste0(imgDIR,"/",flightDIR[i]))
  
}

#first get range of values for quantiles
#for colors

plot(seq(1:256),col=grey(1:256/256),pch=19)
#declare the number of colors needed



flightDataRt <- data.frame()
flightDataR <- data.frame()
flightQ <- list()
for(i in 1:length(flightDIR)){
  flightDataR <- read.csv(paste0(imgDIR,"/",flightDIR[i],"/",flightFiles[[i]][1]),head=FALSE)

  for(j in 2:length(flightFiles[[i]])){
    #read in csv
    flightDataRt <- read.csv(paste0(imgDIR,"/",flightDIR[i],"/",flightFiles[[i]][j]),head=FALSE)
    flightDataR <- rbind(flightDataR,flightDataRt)
  }

  #get data quantiles
  flightQ[[i]] <- quantile(as.vector(data.matrix(flightDataR)), prob=seq(0,1, by=0.05))
  
}

#set up color scheme and digital number
#if values are outside 95% then give NA
#since appear to be outliers that are artifacts of camera
#writing out numbers so that can use conversion later
#doing floor and ceiling rounding
#upper range - lower range

#0 and 255 are reserved for extreme values
#set up table of equal interval breaks
tempS <- list()
dfN <- list()
for(i in 1:length(flightDIR)){
  tempS[[i]] <- round(seq(floor(flightQ[[i]][2]),ceiling(flightQ[[i]][20]), length.out=255),2)

  #set up data frame
  dfN[[i]] <- data.frame(DN=seq(0,255),
                  startT = c(flightQ[[i]][1],tempS[[i]][1:254],ceiling(flightQ[[i]][20])+0.0000000001),
                  endT = c(floor(flightQ[[i]][2]),tempS[[i]][2:255],flightQ[[i]][21]),
                  col=grey(seq(0,1,length.out=256)))
}
#read in csvs and set up tiff for each one
flightDataR <- list()
flightDF <- list()
flightDF2 <- data.frame()
lyseq <- seq(0,255)
subl <- c(1,seq(20,220, by=20),255)
pcol <- character()
#files are 120x 160 pixels
for(i in 1:length(flightDIR)){
  for(j in 1:length(flightFiles[[i]])){
    #read in data file and reorganize
    flightDataR[[j]]<- read.csv(paste0(imgDIR,"/",flightDIR[i],"/",flightFiles[[i]][j]),head=FALSE)
    
    flightDF[[j]] <- data.frame(Y=rep(seq(1,120),each=160),X=rep(seq(1,160),times=120),
                                Temp=as.vector(data.matrix(flightDataR[[j]])))
    #assign a color for each pixel

    for(k in 1:dim(flightDF[[j]])[1]){
      for(m in 1:dim(dfN[[i]])[1]){
        if(flightDF[[j]]$Temp[k] >= dfN[[i]]$startT[m]&flightDF[[j]]$Temp[k] < dfN[[i]]$endT[m]){
          pcol[k] <- dfN[[i]]$col[m]
        }
      }	
      
    }
    flightDF[[j]]$pcol <- pcol
    
    jpeg(paste0(outDIR,"/",flightDIR[i],"/",gsub(".csv","",flightFiles[[i]][j]),".jpg"),
         width=640,height=480, units="px")
    
    par(mai=c(0,0,0,0))	
    plot(c(0,1),c(0,1), type="n", ylim=c(120,0),xlim=c(0,160), xaxs="i",yaxs="i",
         xlab=" ", ylab=" ")
    
    for(k in 1:dim(flightDF[[j]])[1]){
      polygon(c(flightDF[[j]]$X[k]-1,flightDF[[j]]$X[k]-1,flightDF[[j]]$X[k],flightDF[[j]]$X[k]),
              c(flightDF[[j]]$Y[k]-1,flightDF[[j]]$Y[k],flightDF[[j]]$Y[k],flightDF[[j]]$Y[k]-1),
              border=NA, col=flightDF[[j]]$pcol[k])
    }			
    
    dev.off()	
  }
  
  
  #make a legend for the flight color and temp
  jpeg(paste0(outDIR,"/",flightDIR[i],"_temperature_legend.jpg"),width=500,height=1000, units="px")
  layout(matrix(c(1),ncol=1), width=c(lcm(5)), height=c(lcm(30)))	
  
  plot(c(0,1),c(0,1),  type="n", ylim=c(0,255),xlim=c(0,1), xaxs="i",yaxs="i",
       xlab=" ", ylab=" ",axes=FALSE)
  for(k in 1:(254)){
    polygon(c(0,0,1,1), c(lyseq[k],lyseq[k]+1,lyseq[k]+1,lyseq[k]),col=ccol[k], border=NA)
  }
  
  axis(4,lyseq[subl],dfN[[i]]$startT[subl],las=2,cex.axis=2)
  dev.off()
}	


#write color info into dataframe

write.table(dfN[[1]], paste0(outDIR,"/",flightDIR[i],"_temperature_key.jpg"))