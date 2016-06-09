if (!file.exists("summarySCC_PM25.rds")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "data.zip", method = "curl")
  unzip("data.zip")
  rm(url)}
if (!library(dplyr, logical.return = TRUE)){
  install.packages("dplyr")
  library(dplyr)}
if (!library(ggplot2, logical.return = TRUE)){
  install.packages("dplyr")
  library(ggplot2)}

nei <- readRDS("summarySCC_PM25.rds")

# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# Isolate data for Baltimore
t <- nei[nei$fips=="24510",] %>% 
  group_by(year, type) %>% 
  summarize(total.pm25=sum(Emissions))

# Construct and save graph
g <- ggplot(data=t, aes(year, total.pm25))
g <- g + labs(x="Year", y="Total Emissions (tons)") 
g <- g + ggtitle("PM2.5 in Baltimore by Type")
g <- g + geom_point() 
g <- g + stat_smooth(method="lm") 
g <- g + facet_wrap(~type)
ggsave("plot3.png", plot=g, device="png")
rm(nei, t, g)