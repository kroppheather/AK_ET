#starting script to organize data download
# Install rhdf5 package (only need to run if not already installed)
#install.packages("BiocManager")
#BiocManager::install("rhdf5")

# Call the R HDF5 Library
library(rhdf5)


#home directory
dirD <- "/Users/hkropp/Google Drive/research/Healy_ET/NEON_eddy-flux"

test <- list.dirs(dirD)

test2 <- list.files(test[2])

day1 <- test2[2]

day1data <- H5Fopen(paste0(test[2],"/",day1))

str(day1data$HEAL)

head(day1data$objDesc)