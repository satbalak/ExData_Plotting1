plot4 <- function() {
    library(data.table)
    library(lubridate)
    library(dplyr)
    
    ### Check if the zip file exists, if it does not exist, then download file
    if (!file.exists("exdata-data-household_power_consumption.zip")) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, destfile = "./exdata-data-household_power_consumption.zip")
    }
    
    
    ##unzip the file, but remove the file before unzipping
    if (file.exists("household_power_consumption.txt")){
        file.remove("household_power_consumption.txt")
    }
    unzip("./exdata-data-household_power_consumption.zip")
    
    #read the fulldata
    cc <- c("Date")
    fd <- read.table("household_power_consumption.txt", sep=";"
                       ,na.strings="?", header = TRUE, stringsAsFactors=FALSE)
    fd <- data.table(fd)
    
    # get only the 1st and 2nd Feb 2007 data into another table
    # then merge the Date and Time columns into a POSIXct column
    # and set the column order
    d <- fd[Date == "1/2/2007" | Date == "2/2/2007", ]
    d$DateTime <- dmy_hms(paste(d$Date, d$Time))
    mydt <- d %>% select(-Date, -Time) %>%
            setcolorder(c(8,1:7))
    
    
    # Now, we have data in the format we want and can go on to plotting
    png(filename="plot4.png", width=480, height=480)
    # set mfrow to 2,2 to allow for 4 plots
    par(mfrow = c(2,2))
    
    # Draw the first plot
    with(mydt, plot(DateTime, Global_active_power, type="l", xlab=""
                    , ylab="Global Active Power (kilowatts)"))

    # Draw the second plot
    with(mydt, plot(DateTime, Voltage, type="l", xlab="datetime"
                    , ylab="Voltage"))
    
    # Draw the third plot
    with(mydt, plot(DateTime, Sub_metering_1, type="n", xlab=""
                  , ylab="Energy sub metering"))
    lines(mydt$DateTime, d1$Sub_metering_1, col="black")
    lines(mydt$DateTime, d1$Sub_metering_2, col="red")
    lines(mydt$DateTime, d1$Sub_metering_3, col="blue")
    legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
           , lty=c(1,1), col=c("black","red","blue"), bty="n")
    
    #Draw the fourth plot
    with(mydt, plot(DateTime, Global_reactive_power, type="l", xlab="datetime"
                    , ylab="Global_reactive_power"))
    dev.off()

}