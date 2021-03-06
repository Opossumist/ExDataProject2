if (!file.exists("summarySCC_PM25.rds")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "data.zip", method = "curl")
  unzip("data.zip")
  rm(url)}
if (!library(dplyr, logical.return = TRUE)){
  install.packages("dplyr")
  library(dplyr)}

nei <- readRDS("summarySCC_PM25.rds")

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.

t <- nei %>% 
  group_by(year) %>% 
  summarize(total.pm25=sum(Emissions))

# Open the device, plot the graph, and close the device.
png("plot1.png")
plot(total.pm25~year, data=t,
     main="Plot 1 - Total PM2.5 Emissions of US by Year",
     ylab="PM2.5 Emissions (tons)",
     xlab="Year",
     pch=16)
abline(lm(total.pm25~year, data=t),
       lty=2)
dev.off()
rm(nei, t)
