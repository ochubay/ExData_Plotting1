
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
    
    ##convert character Date and Time fields from the dataset into POSIXlt type and store in a separate vector
    dt <- with(poweruse, strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))
    
    ##add Date/Time vector dt as a column to poweruse and store the result in poweruse2
    poweruse2 <- cbind(dt, poweruse)
    
    if(isPNG) {
      ##activating PNG file device
      png(filename="plot2.png", width=480, height=480)  
    }
    
    ## printing power usage data
    with(poweruse2, plot(dt, Global_active_power, type="l", xlab="", 
                         ylab="Global Active Power (kilowatts)"))
    
    if (isPNG) {
      ## restoring the device back to the default value
      dev.off()  
      
      print("The plot was successfully printed. Please check plot2.png file in your current directory.")
    }
    
} else {
  print("Data file is NOT found. Please make sure that it's located in the same directory as the script.")
}
