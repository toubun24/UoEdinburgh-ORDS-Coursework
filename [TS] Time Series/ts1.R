library(rmarkdown)
setwd("E:/OneDrive/ORDS2/[TS] Time Series/Assignments/TS A1")

# 1

# input, header=FALSE, sep=""
bgd <-read.table("bgd.txt")
crime <- read.table("crime.txt")
# transfer into time series
bgd <- ts(bgd[,2])
crime <- ts(crime[,2])

# plot
par(mfrow=c(2,1))
plot(bgd, xlab="t")
plot(crime, xlab="t")

# 2

# Ljung-Box test
Box.test(bgd, type="Ljung-Box", lag=5)
Box.test(crime, type="Ljung-Box", lag=5)

# 3

# plot acf and pacf
par(mfrow=c(1,2))
acf(bgd)
pacf(bgd)
par(mfrow=c(1,2))
acf(crime)
pacf(crime)

# AR(1):x=0.5x'+w
# AR(2):x=0.7x'+0.2x''+w

# 4

bgd_ar2 <- arima(x=bgd, order=c(2, 0, 0))
bgd_ar2

bgd_coef <- bgd_ar2$coef[1:3]
names(bgd_coef) <- c("a1","a2","mu")
bgd_coef

crime_ar2 <- arima(x=crime, order=c(2, 0, 0))
crime_ar2

crime_coef <- crime_ar2$coef[1:3]
names(crime_coef) <- c("a1","a2","mu")
crime_coef

# 6 (p74)

# 1. Plotting the residuals
par(mfrow=c(2,1))
bgd_res <- bgd_ar2$residuals
crime_res <- crime_ar2$residuals
plot(bgd_res, ylab="Residuals of bgd in AR(2)")
plot(crime_res, ylab="Residuals of crime in AR(2)")

# 2. Obtaining a correlogram of the residuals
par(mfrow=c(2,2))
acf(bgd_res, main="Residuals of bgd in AR(2)")
pacf(bgd_res, main="Residuals of bgd in AR(2)")
acf(crime_res, main="Residuals of crime in AR(2)")
pacf(crime_res, main="Residuals of crime in AR(2)")

# 3. Examining the Ljung-Box statistic of the residuals
bgd_p <- sapply(1:10, function(lag) Box.test(bgd_res, type="Ljung-Box", lag)$p.value)
crime_p <- sapply(1:10, function(lag) Box.test(crime_res, type="Ljung-Box", lag)$p.value)
par(mfrow=c(1,2))
plot(bgd_p,type="b", xlab="lag", ylab="Ljung-Box test for bgd residuals")
plot(crime_p,type="b", xlab="lag", ylab="Ljung-Box test for crime residuals")

# 4. lag plot
lag.plot(bgd_res, type="p", lag=9, do.lines=FALSE, main="Autocorrelations for bgd residuals")
lag.plot(crime_res, type="p", lag=9, do.lines=FALSE, main="Autocorrelations for crime residuals")

# 5. tsdiag
tsdiag(bgd_ar2)
tsdiag(crime_ar2)

# output
render("ts1.Rmd")
help(par)
help(plot)
