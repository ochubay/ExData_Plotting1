
datafile <- "household_power_consumption.txt"
isPNG <- TRUE ##  if isPNG == TRUE then print to PNG device, othrwise print to the screen

if(file.exists(datafile)) {
  
    ## compute the location and size of [Feb-01'07 - Feb-02'07] range of records in the dataset
    startdt <- strptime("16/12/2006 17:24:00", "%d/%m/%Y %H:%M:%S")
    startdtFeb01 <- strptime("1/2/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
    skiprec <- difftime(startdtFeb01, startdt, units="mins") + 1 ## add 1 to compensate for header in the file
    framesize <- 2 * 24 * 60
    
      ## read [Feb-01'07 - Feb-02'07] range of records in the file without headers
    poweruse <- read.table(datafile, header=FALSE, sep=";",
                           skip=skiprec, nrows = framesize, na.strings = "?")
    
    ## add headers
    headers <- read.table(datafile, header=TRUE, sep=";", nrows = 1)
    names(poweruse) <- names(headers)
    
    if(isPNG) {
          ##activating PNG file device
          png(filename="plot1.png", width=480, height=480)  
    }
    
    ## printing power usage data into the historgam
    ## since the range between min and max of Global_active_power is ~4, setting breaks to ~4*2
    hist(poweruse$Global_active_power, breaks=16, col="red", 
         main = "Global Active Power", xlab="Global Active Power (kilowatts)")
    
    if (isPNG) {
          ## restoring the device back to the default value
          dev.off()  
      
          print("Histogram was successfully printed. Please check plot1.png file in your current directory.")
    }

} else {
  print("Data file is NOT found. Please make sure that it's located in the same directory as the script.")
}
