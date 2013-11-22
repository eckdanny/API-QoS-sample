# Read in the Data
data <- read.csv(
    file="curl_results.csv"
  , head=TRUE
  , sep=","
  , colClasses=c("character", "factor", rep("numeric", 3))
)
# Init Graphic Device
jpeg(
    filename='plot.jpg'
  , width=800
  , height=500
)
# Setup Graphical Params
par(
    mfrow=c(2,1)
  , mar=c(4,4,2,0.5)
  , oma=c(0,0,0,0)
)
# Add a Scatter plot
plot(
    x=data$time_total
  , y=data$size_download/1000
  , asp=2
  , log="y"
  , xlab="time (s)"
  , ylab="size (kb)"
  , main="Payload vs Response Times"
)
# Indicate 500ms threshold
abline(
    v=0.5
  , col="red"
)
# Add a Bar plot
barplot(
    height=data$time_total*1000
  , ylim=c(100, 25000)
  , asp=2
  , log="y"
  , xlab="Requests"
  , ylab="time (ms)"
  , main="Response Times"
)
# Indicate 500ms threshold
abline(
    h=500
  , col="red"
)
# Close Graphic Device
invisible(dev.off())

# Create Histogram-like QoS Distribution
jpeg(
    filename='qos.jpg'
  , width=500
  , height=500
)
# Response times in seconds
rtimes <- data$time_total * 1000
rtimes.hist <- hist(
    x=rtimes
  , breaks=c(0,200, 500, 1500, 5000, max(rtimes)+1)
  , plot=FALSE
)
# Create the plot (groupings from breaks)
barplot(
    height=rtimes.hist$counts
  , ylim=c(0, max(rtimes.hist$counts)+1)
  , main="API QoS Distribution"
  , xlab="Response Time (ms) Groups"
  , ylab="Number of Occurences"
  , names.arg=c("<200", "200-500", "500-1500", "1500-5000", ">5000")
)
# Close Graphic Device
invisible(dev.off())

# Output the timeout UPCs
# subset(data, time_total > 15, select="upc")
sink("summary.txt", append=FALSE, split=FALSE)
summary(data$time_total)
cat("\n  Std Dev: ", sd(data$time_total), "\n")
sink()
