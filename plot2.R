if (!file.exists("summarySCC_PM25.rds")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "data.zip", method = "curl")
  unzip("data.zip")
  rm(url)}
if (!library(dplyr, logical.return = TRUE)){
  install.packages("dplyr")
  library(dplyr)}

nei <- readRDS("summarySCC_PM25.rds")

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

t <- nei[nei$fips=="24510",] %>% 
  group_by(year) %>% 
  summarize(total.pm25=sum(Emissions))

# Open the device, plot the graph, and close the device.
png("plot2.png")
plot(total.pm25~year, data=t,
     main="Total PM2.5 Emissions by Year in Baltimore City",
     ylab="Total PM2.5 Emissions",
     xlab="Year",
     pch=16)
abline(lm(total.pm25~year, data=t),
       lty=2)
dev.off()