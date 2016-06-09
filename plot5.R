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

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# Find SCC code for all vehicle sources
mv <- scc[grep("^Mobile", scc$EI.Sector), c("SCC", "EI.Sector")]
mv <- as.character(mv$SCC)

# Isolate data for sources from coal
tmv <- nei[(nei$SCC %in% mv & nei$fips =="24510"),] %>%
  group_by(year) %>%
  summarize(total.pm25=sum(Emissions))
rm(mv, nei, scc)

# Construct and save graph
g <- ggplot(data=tmv, aes(year, total.pm25))
g <- g + geom_point()
g <- g + geom_smooth(method="lm")
g <- g + labs(x="Year", y="Total Emissions (tons)")
g <- g + scale_y_continuous(limits=c(0,NA))
g <- g + ggtitle("Baltimore PM2.5 Trend for All Mobile Sources")
ggsave("plot5.png", plot=g, device="png")
rm(tmv, g)
