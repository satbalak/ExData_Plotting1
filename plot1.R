plot1 <- function() {
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
    png(filename="plot1.png", width=480, height=480)
    hist(d1$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
    dev.off()

}