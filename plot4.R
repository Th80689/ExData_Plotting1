##plot4.R

old.dir <- getwd()

## determine your own working directory - if necessary
wd <- c("C:/Users/Thomas/Documents/Coursera_4_Exploratory_Data_Analysis/git_source")

setwd(wd)

## check for raw data - and get it only if necessary 

## check for folder
urlId <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
target <- "./data/household_power_consumption.zip"


if (!file.exists("/data")){
  dir.create("data")
}

## check for rawdata
if (!file.exists("./data/household_power_consumption.zip")) {
  setInternet2(TRUE)  
  download.file(urlId,target, method="internal", mode = "wb") ## parameters for Windows  
}

## check whether tidy data exists already or whether unzip and cleaning is necessary
if(file.exists(target)){
unzip(target, exdir="./data")
  }

require("data.table")
temp <- fread("./data/household_power_consumption.txt", na.strings=c("NA"))

## subset
pdata <- temp[(Date=="1/2/2007" | Date == "2/2/2007"),]
## cleanup memory
rm("temp")

## create and format datetime variable
pdata[,datetime:=paste(pdata$Date, pdata$Time, sep = " ")]
pdata$datetime <- as.POSIXct(strptime(pdata$datetime, "%d/%m/%Y %H:%M:%S"))

## mutate Global_active_power to numeric
pdata$Global_active_power <- as.numeric(pdata$Global_active_power)

## open file device
pname <- c("plot4.png")

png(pname, width = 480, height = 480)


## create plot
## set placeholder for four plots
par(mfrow = c(2,2))
##1 
with(pdata, plot(y = Global_active_power,
                x = datetime, type = "l",
                ylab="Global Active Power",
                xlab = ""))
##2
with(pdata, plot(y = as.numeric(as.character(pdata$Voltage)), x = datetime,
                type ="l", xlab = "datetime",
                ylab = "Voltage"))

##3
plot(y = as.numeric(pdata$Sub_metering_1), x = pdata$datetime, type = "l", col = "black",
     yaxt="n", ylab = "Energy sub metering", ylim =c(-.1, 40), xlab = "")
axis(2, at = c(0,10,20,30))
lines(pdata$datetime, as.numeric(pdata$Sub_metering_2), col = "red", type = "l")
lines(pdata$datetime, as.numeric(pdata$Sub_metering_3), col = "blue", type = "l")
legend("topright", cex = 0.7,
       pch = 1, col = c("black","red", "blue"), bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
##4
with(pdata, plot(y = as.numeric(Global_reactive_power),
                x = datetime, type = "l", ylab = "Global_reactive_power",
                xlab = "datetime"))

## close file
dev.off()

## check for created plot
if(file.exists(pname)){
  print(paste(pname, " successfully created"))
}


## restore old working directory
setwd(old.dir)