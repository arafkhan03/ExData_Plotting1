#Data Download & Extract
if(!dir.exists("Raw Data")) { dir.create("Raw Data") }

file.url   <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file.path  <- "data/household_power_consumption.zip"
file.unzip <- "data/household_power_consumption.txt"

if(!file.exists(file.path) & !file.exists(file.unzip)) {
    download.file(file.url, file.path)
    unzip(file.path, exdir = "Raw Data")
}


#Data Load
install.packages("tidyverse")
library(tidyverse)
library(lubridate)
df <- read_delim("Raw Data/household_power_consumption.txt",
                 delim = ";",
                 na    = c("?"),
                 col_types = list(col_date(format = "%d/%m/%Y"),
                                  col_time(format = ""),
                                  col_number(),
                                  col_number(),
                                  col_number(),
                                  col_number(),
                                  col_number(),
                                  col_number(),
                                  col_number())) %>%
    filter(between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))



#Plotting

df <- mutate(df, datetime = ymd_hms(paste(Date, Time)))

png("plot4.png",
    width  = 480,
    height = 480)

par(mfrow = c(2, 2))

# Plot 1: Top Left

plot(Global_active_power ~ datetime, df, type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = NA)

# Plot 2: Top Right

plot(Voltage ~ datetime, df, type = "l")

# Plot 3: Bottom Left

plot(Sub_metering_1 ~ datetime, df, type = "l",
     ylab = "Energy sub metering",
     xlab = NA)

lines(Sub_metering_2 ~ datetime, df, type = "l", col = "red")

lines(Sub_metering_3 ~ datetime, df, type = "l", col = "blue")

legend("topright",
       col = c("black",
               "red",
               "blue"),
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       lty = 1,
       bty = "n")

# Plot 4: Bottom Right

plot(Global_reactive_power ~ datetime, df, type = "l")

dev.off()

