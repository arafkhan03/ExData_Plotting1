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

plot(Global_active_power ~ datetime, df, type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = NA)

dev.copy(png, "plot2.png",
         width  = 480,
         height = 480)

dev.off()


