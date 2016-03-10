## Week 2 Lab Interpolating Yield Curve
## Wei Wei
## MFE Programming workshop 2015

library(lubridate)
library(xts)

## To read in the data I copied it into a file using excel
## saved it to a csv and then imported it
datain <- read.csv("week2data.csv")
 
## just get a single subset of the data, the last row
# [row #, all columns]
dataset <- datain[nrow(datain),]

## grab the date of my observation
firstdate <- mdy(dataset[,1])

## now drop the date
# negative index of a vector strips the member whose position has the same absolute value as the negative index.
yields <- dataset[1,-1]

## being fancy cleaning up the maturities of the yields
## you could just manually create the durations but this
## is kind of fun... 
maturity <- names(yields) # get the names of vector "yields" and put these strings in vector "maturity"
## replace the . with a space
maturity <- gsub("\\."," ",maturity)
## replace the X with nothing
maturity <- gsub("X","",maturity)
## change to years and months
maturity <- gsub("Mo","months",maturity)
maturity <- gsub("Yr","years",maturity)

## split at the space
maturity <- strsplit(maturity, " ")

## convert to durations using lubridate
## note that the durations aren't exactly perfect for when the
## actual bonds are likely to expire, but this is a good first pass
# duration() display as the number of seconds in a time span
# sapply(X, FUN) applies each row of X as input argument to FUN. 把list maturity中的每个字符串记录的时间段转化为秒数
durations <- sapply(maturity,function(x) duration(as.numeric(x[1]),x[2]))

## finally get the start date plus the duration
## I round down to the nearest day because it also adds on time of day
# 惊奇惊奇惊奇，firstdate是一个值，durations是一个向量，R可以令它们相加！
outdates <- floor_date(firstdate+durations,"day")

## create the XTS object
## also note that I convert the yeilds to a vector
yielddata <- as.xts(as.numeric(yields),order.by=outdates)

## now plot
plot(yielddata)

## get a sequence of all of the dates
firstdate <- start(yielddata)
lastdate <- end(yielddata)
alldates <- seq(firstdate,lastdate,by="1 day")

## create an empty xts
fullsample <- xts(order.by = alldates)
## merge in the known data
fullsample <- merge(fullsample,yielddata)

## and now get the approximations
fullsample_linear <- na.approx(fullsample)
fullsample_spline <- na.spline(fullsample)

## merge together and plot with zoo
allseries <- merge(yielddata, fullsample_linear)
allseries <- merge(allseries, fullsample_spline)

# xts object row为时间，可以有多个column
## Set a color scheme:
tsRainbow <- rainbow(ncol(allseries))

## Plot the series with plot.zoo which is better
## for plotting multiple series
plot.zoo(x = allseries, 
         col = tsRainbow, screens = 1)

legend(x = "topleft", legend = c("Original", "Linear", "Spline"), 
       lty = 1,col = tsRainbow)
