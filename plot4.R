## Save data file (household_power_consumption.txt) to working directory

## This script deletes existing datasets if this code has already been run, or if 
## multiple plots are generated in a single session

unlink("shortdata.txt")

## This function reads the data line by line and then writes only those lines with 
## the relevant date range.

readdata <- function(data){
    x <- readLines(data, n = 1)
    write(x, file = "shortdata.txt", append = TRUE, sep = ";")
    
    x <- readLines(data, n = 1)
    while (length(x) >= 1){
        y <- substr(x,1,8)
        if (y == "1/2/2007"|y== "2/2/2007")
        {write(x, file = "shortdata.txt", append = TRUE, sep = ";")
        }
        
        x <- readLines(data, n = 1)  
    }
}

## This section runs the function against the data - be sure the data is in your 
## working directory.

datafile <- file("household_power_consumption.txt", open = "rt")
readdata(datafile)
close(datafile)

## This code reads in the remaining data.

finaldata <- read.table("shortdata.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)

## This code turns the date fields into one date and binds the new date field to 
## the existing data.

library(lubridate)
cleaneddate <- paste(finaldata$Date, finaldata$Time, sep = " ")
fulldate <- dmy_hms(cleaneddate)
completedata <- cbind (fulldate, finaldata)

## This code creates the plot in png and saves the file.

png(file = "plot4.png", width=480,height=480) 
par(mfrow = c(2, 2))
with(completedata, {    

    plot(completedata$fulldate, completedata$Global_active_power, 
         type = "l", 
         xlab = "", 
         ylab = "Global Active Power")  
    plot(completedata$fulldate, completedata$Voltage,
         type = "l",
         xlab = "datetime",
         ylab = "Voltage")
    
    plot(completedata$fulldate, 
         completedata$Sub_metering_1,
         type = "n", 
         xlab = "", 
         ylab = "Energy sub metering")
    lines(completedata$fulldate, 
          completedata$Sub_metering_1, type = "l")
    lines(completedata$fulldate, 
          completedata$Sub_metering_2, type = "l", col = "red")
    lines(completedata$fulldate, 
          completedata$Sub_metering_3, type = "l", col = "blue")
    legend("topright", 
           col = c("black","red", "blue"), 
           legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"),
           lwd = 1)
    plot(completedata$fulldate, completedata$Global_reactive_power,
         type = "l",
         xlab = "datetime",
         ylab = "Global_reactive_power")  
})

## This code clears the png connection.

dev.off()

