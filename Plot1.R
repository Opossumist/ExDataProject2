if (!file.exists("summarySCC_PM25.rds")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, data.zip, method = "curl")
  unzip (data.zip)}
if (!library(dplyr, logical.return = TRUE)){
  install.packages("dplyr")
  library(dplyr)}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.
t <- NEI %>% 
  group_by(year) %>% 
  summarize(total.pm25=sum(Emissions))

