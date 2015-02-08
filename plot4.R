

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - estimate dataset size
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - The dataset has 2,075,259 rows and 9 columns. First calculate a rough 
#   estimate of how much memory the dataset will require in memory before 
#   reading into R
# - estimate is 142.5Mb
mem_bytes <- 2075259 * 9 * 8
bytes_per_mb_base2 <- 2^20
mem_mb <- round(mem_bytes / bytes_per_mb_base2,2)
#print(paste("estimated memory for dataset:", mem_mb,"Mb"))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - load all the data into memory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - load time is 25.5s (system.time) obj size is 143Mb
# - very marginal improvement with loading with colClasses specified 
dataPath <- "./household_power_consumption.txt"
powerDataRaw <- read.csv(file=dataPath, sep=";", stringsAsFactors=F, na.strings = "?")
#print(paste("actual object size:",format(object.size(powerData), units="Mb")))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - clean up the data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - make copy of raw data since we are going to update and subset
powerData <- powerDataRaw
# - remove NA values
powerData <-na.omit(powerData)
# - subset the data (m/d/yyyy)
#   do this early to improve performace for other cleaning steps
powerData <- powerData[powerData$Date %in% c("1/2/2007", "2/2/2007"),]
# - add DateTime variable
powerData$DateTime <- strptime(paste(powerData$Date,powerData$Time), "%d/%m/%Y %H:%M:%S")
# - convert to date object
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y")
# - convert to time object
powerData$Time <- strptime(powerData$Time, "%H:%M:%S")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - construct plot 4
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - open PNG graphics device
png("plot4.png", width = 480, height = 480, units = "px")
# - partition page for 4 plots, by row
par(mfrow=c(2,2))
# - build upper left plot
plot(x=powerData$DateTime, y=powerData$Global_active_power, 
     type="l", 
     ylab="Global Active Power",
     xlab="",
     col="black")
# - build upper right plot
plot(x=powerData$DateTime, y=powerData$Voltage, 
     type="l", 
     ylab="Voltage",
     xlab="datetime",
     col="black")
# - build lower left plot
plot(x=powerData$DateTime, y=powerData$Sub_metering_1,
     type="l", 
     ylab="Energy sub metering",
     xlab="",
     col="black")
lines(powerData$DateTime, powerData$Sub_metering_2, col="red")
lines(powerData$DateTime, powerData$Sub_metering_3, col="blue")
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=1,
       col=c("black", "red", "blue"),
       bty="n")
# - build lower right plot
plot(x=powerData$DateTime, y=powerData$Global_reactive_power, 
     type="l", 
     ylab="Global_reactive_power",
     xlab="datetime",
     col="black")
# - close file device
dev.off()


