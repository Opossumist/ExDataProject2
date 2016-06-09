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
ssc <- readRDS("Source_Classification_Code.rds")

# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999–2008?

# Find SCC code for coal sources
coal <- scc[grep("Coal", scc$EI.Sector), c("SCC", "EI.Sector")]
coal$SCC <- as.character(coal$SCC)
coal <- as.character(coal$SCC)

# Isolate data for sources from coal
tcoal <- nei[nei$SCC %in% coal,] %>%
  group_by(year) %>%
  summarize(total.pm25=sum(Emissions))

# Construct and save graph
g <- ggplot(data=tcoal, aes(year, total.pm25))
g <- g + geom_point()
g <- g + geom_smooth(method="lm")
g <- g + labs(x="Year", y="Total Emissions (tons)")
g <- g + ggtitle("National PM2.5 Trend for Coal")
ggsave("plot4.png", plot=g, device="png")
rm(nei, scc, coal, tcoal, g)
