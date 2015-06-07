##plot2.R

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
pdata$datetime <-  as.POSIXct(strptime(pdata$datetime, "%d/%m/%Y %H:%M:%S"))

## mutate Global_active_power to numeric
pdata$Global_active_power <- as.numeric(pdata$Global_active_power)

## open file device

pname <- c("plot2.png")

png(pname, width = 480, height = 480)

## create plot
with(pdata, plot(y = Global_active_power, x = datetime, type ="l",
                ylab ="Global Active Power (kilowatts)", xlab =""))

## close file
dev.off()

## check for created plot
if(file.exists(pname)){
  print(paste(pname, " successfully created"))
}


## restore old working directory
setwd(old.dir)
