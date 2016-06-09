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

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽").
# Which city has seen greater changes over time in motor vehicle emissions?
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# Find SCC code for all vehicle sources
mv <- scc[grep("^Mobile", scc$EI.Sector), c("SCC", "EI.Sector")]
mv <- as.character(mv$SCC)

# Isolate data for emissions from vehicles by location, and name
tmv <- nei[(nei$SCC %in% mv & nei$fips %in% c("24510", "06037")),] %>%
  rename(location=fips) %>%
  group_by(year, location) %>%
  summarize(total.pm25=sum(Emissions))
tmv$location <- sub("24510", "Baltimore City", tmv$location)
tmv$location <- sub("06037", "Los Angeles County", tmv$location)
rm(mv, nei, scc)

# Construct and save graph
g <- ggplot(data=tmv, aes(year, total.pm25))
g <- g + geom_point()
g <- g + geom_smooth(method="lm")
g <- g + labs(x="Year", y="Total Emissions (tons)")
g <- g + facet_wrap(~location)
g <- g + scale_y_continuous(limits=c(0,NA))
g <- g + ggtitle("Plot 6 - PM2.5 Emissions Comparison")
ggsave("plot6.png", plot=g, device="png")
rm(tmv, g)
