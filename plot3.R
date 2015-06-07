##plot3.R

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
temp <- fread("./data/household_power_consumption.txt", na.strings="NA")

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

pname <- c("plot3.png")

png(pname, width = 480, height = 480)


## create plot
plot(y = as.numeric(pdata$Sub_metering_1), 
     x = pdata$datetime, type = "l", col = "black",
     xlab ="",
     yaxt="n", ylab = "Energy sub metering", ylim = c(-.1,40))
axis(2, at = c(0,10,20,30))
lines(pdata$datetime, as.numeric(pdata$Sub_metering_2), col = "red", type = "l")
lines(pdata$datetime, pdata$Sub_metering_3, col = "blue", type = "l")
legend("topright", pch = 1, col = c("black","red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## close file
dev.off()

## check for created plot
if(file.exists(pname)){
  print(paste(pname, " successfully created"))
}

## restore old working directory
setwd(old.dir)