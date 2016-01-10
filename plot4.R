
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
      png(filename="plot4.png", width=480, height=480)  
    }
    
    ## set 2 x 2 area for 4 charts
    par(mfrow=c(2,2))
    

    ## printing chart #1 - Global Active Power
    with(poweruse2, plot(dt, Global_active_power, type="l", xlab="", 
                         ylab="Global Active Power"))
    
    ## printing chart #2 - Voltage
    with(poweruse2, plot(dt, Voltage, type="l", xlab="datetime", 
                         ylab="Voltage"))
    
    ## printing chart #3 - Energy sub metering
    ## initializing plot area (type='n')
    with(poweruse2, plot(dt, Sub_metering_1, type="n", xlab="", 
                         ylab="Energy sub metering"))
    
    ## printing power usage data
    with(poweruse2, lines(dt, Sub_metering_1, col="black"))
    with(poweruse2, lines(dt, Sub_metering_2, col="red"))
    with(poweruse2, lines(dt, Sub_metering_3, col="blue"))
    
    ## adding legend 
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty=1, lwd=2, xjust=0, col=c("black", "red", "blue"), bty="n")
    
    
    ## printing chart #4 - Global_reactive_power
    with(poweruse2, plot(dt, Global_reactive_power, type="l", xlab="datetime", 
                         ylab="Global_reactive_power"))
    

    if (isPNG) {
      ## restoring the device back to the default value
      dev.off()  
      
      print("The plot was successfully printed. Please check plot4.png file in your current directory.")
    }
    
} else {
  print("Data file is NOT found. Please make sure that it's located in the same directory as the script.")
}
