library(rmarkdown)
library(mice)
library(JointAI)
library(devtools)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(lattice)
library(mitml)
# library(tidyverse)
# library(corrplot)
source_url("https://gist.githubusercontent.com/NErler/0d00375da460dd33839b98faeee2fdab/raw/c6f537ecf80eddcefd94992ec7926aa57d454536/propplot.R")
setwd("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 3")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 3/dataex2(3).Rdata")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 3/dataex4(3).Rdata")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 3/NHANES2(1).Rdata")

# output
render("ida3.Rmd")

# 1
# a
n1 <- dim(nhanes)[1]
sum(is.na(rowSums(nhanes)))/n1

# b
imps1b <- mice(nhanes, printFlag = FALSE, seed = 1)
fits1b <- with(imps1b, lm(bmi ~ age + hyp + chl))
ests1b <- pool(fits1b)
summary(ests1b, conf.int = TRUE)[, c(2, 3, 6, 7, 8)]
pvar1b <- t(ests1b$pooled['lambda'])[1:4]
names(pvar1b) <- c("intercept", "age", "hyp", "chl")
pvar1b

# c
pvars1c <- matrix(nrow = 5, ncol = 4)
dimnames(pvars1c) <- list(c(2:6), c("intercept", "age", "hyp", "chl"))
for(i in 2:6)
{
  imps1c <- mice(nhanes, printFlag = FALSE, seed = i)
  fits1c <- with(imps1c, lm(bmi ~ age + hyp + chl))
  ests1c <- pool(fits1c)
  print(summary(ests1c, conf.int = TRUE)[, c(2, 3, 6, 7, 8)])
  pvars1c[i-1, ] <- t(ests1c$pooled['lambda'])
}
pvars1c

# d
pvars1d <- matrix(nrow = 5, ncol = 4)
dimnames(pvars1d) <- list(c(2:6), c("intercept", "age", "hyp", "chl"))
for(i in 2:6)
{
  imps1d <- mice(nhanes, m = 100, printFlag = FALSE, seed = i)
  fits1d <- with(imps1d, lm(bmi ~ age + hyp + chl))
  ests1d <- pool(fits1d)
  print(summary(ests1d, conf.int = TRUE)[, c(2, 3, 6, 7, 8)])
  pvars1d[i-1, ] <- t(ests1d$pooled['lambda'])
}
pvars1d

# 2
n2 <- length(dataex2[1, 1, ])
param2nob <- param2boot <- rep(NA, n2)
i=1
for(i in 1:n2)
{
  # not acknowledged parameter uncertainty
  imps2nob <- mice(dataex2[, , i], m = 20, method = "norm.nob", printFlag = FALSE, seed = 1)
  fits2nob <- with(imps2nob, lm(Y ~ X))
  ests2nob <- pool(fits2nob)
  param2nob[i] <- ests2nob$pooled[2, 3]
  # acknowledged parameter uncertainty
  imps2boot <- mice(dataex2[, , i], m = 20, method = "norm.boot", printFlag = FALSE, seed = 1)
  fits2boot <- with(imps2boot, lm(Y ~ X))
  ests2boot <- pool(fits2boot)
  param2boot[i] <- ests2boot$pooled[2, 3]
}
quantile(param2nob, c(0.025, 0.975))
quantile(param2boot, c(0.025, 0.975))

# 4
# a
imps4a <- mice(dataex4, printFlag = FALSE, seed = 1)
long <- mice::complete(imps4a, "long", include = TRUE)
long$x1x2 <- with(long, x1*x2)
imps4a <- as.mids(long)
visSeq <- imps4a$visitSequence
visSeq
fits4a <- with(imps4a, lm(y ~ x1 + x2 + x1x2))
ests4a <- pool(fits4a)
beta4a <- summary(ests4a, conf.int = TRUE)[c(2:4), c(2, 7, 8)]
rownames(beta4a) <- c("beta1", "beta2", "beta3")
beta4a

# b
x1x2 <- dataex4$x1 * dataex4$x2
dataex4b <- cbind(dataex4, x1x2)
m=make.method(dataex4b)
m["x1x2"] <- "~I(x1*x2)"
p=make.predictorMatrix(dataex4b)
p[c("x1", "x2"), "x1x2"] <- 0
imps4b <- mice(dataex4b, meth = m, pred = p, printFlag = FALSE, seed = 1)
fits4b <- with(imps4b, lm(y ~ x1 + x2 + x1x2))
ests4b <- pool(fits4b)
beta4b <- summary(ests4b, conf.int = TRUE)[c(2:4), c(2, 7, 8)]
rownames(beta4b) <- c("beta1", "beta2", "beta3")
beta4b

# c
imps4c <- mice(dataex4b, printFlag = FALSE, seed = 1)
#imps4c$predictorMatrix
#imps4c$predictorMatrix[c("x1", "x1x2"), c("x1", "x1x2")] <- 0
#imps4c$predictorMatrix[c("x2", "x1x2"), c("x2", "x1x2")] <- 0
#imps4c$predictorMatrix
fits4c <- with(imps4c, lm(y ~ x1 + x2 + x1x2))
ests4c <- pool(fits4c)
beta4c <- summary(ests4c, conf.int = TRUE)[c(2:4), c(2, 7, 8)]
rownames(beta4c) <- c("beta1", "beta2", "beta3")
beta4c

# 5
dim(NHANES2)
str(NHANES2)
summary(NHANES2)[, 1:6]; summary(NHANES2)[, 7:12]
mdpat_mice <- md.pattern(NHANES2)
# mdpat_mice
require(JointAI)
md_pattern(NHANES2, pattern = FALSE, color = c('#34111b', '#e30f41'))
par(mar = c(3, 3, 2, 1), mgp = c(2, 0.6, 0))
plot_all(NHANES2, breaks = 30, ncol = 4)
imp5 <- mice(NHANES2, maxit = 0)
imp5
#meth5 <- imp5$method
#meth5["hgt"] <- "norm"
#meth5
#imps5 <- mice(NHANES2, method = meth5, maxit = 20, m = 30, seed = 1, printFlag = FALSE)
imps5 <- mice(NHANES2, maxit = 20, m = 30, seed = 1, printFlag = FALSE)
imps5$loggedEvents
plot(imps5, layout = c(4,4))
densityplot(imps5)
densityplot(imps5, ~SBP|hypten + gender)
densityplot(imps5, ~hgt|gender)
require(devtools)
require(reshape2)
require(RColorBrewer)
require(ggplot2)
source_url("https://gist.githubusercontent.com/NErler/0d00375da460dd33839b98faeee2fdab/raw/c6f537ecf80eddcefd94992ec7926aa57d454536/propplot.R")
propplot(imps5)
xyplot(imps5, hgt ~ wgt | gender, pch = c(1, 20))
fits5 <- with(imps5, lm(wgt ~ gender + age + hgt + WC))
summary(fits5$analyses[[1]])
comp5 <- complete(imps5, 1)
plot(fits5$analyses[[1]]$fitted.values, residuals(fits5$analyses[[1]]),
     xlab = "Fitted values", ylab = "Residuals")
boxplot(comp5$wgt ~ comp5$gender, xlab = "gender", ylab = "weight")
plot(comp5$wgt ~ comp5$age, xlab = "age", ylab = "weight")
plot(comp5$wgt ~ comp5$hgt, xlab = "height", ylab = "weight")
plot(comp5$wgt ~ comp5$WC, xlab = "waist circumference", ylab = "weight")
qqnorm(rstandard(fits5$analyses[[1]]), xlim = c(-4, 4), ylim = c(-6, 6))
qqline(rstandard(fits5$analyses[[1]]), col = 2)
pooled_ests5 <- pool(fits5)
summary(pooled_ests5, conf.int = TRUE)
pool.r.squared(pooled_ests5, adjusted = TRUE)
fit_no_gender <- with(imps5, lm(wgt ~ age + hgt + WC))
D1(fits5, fit_no_gender)
D3(fits5, fit_no_gender)
pooled_ests5_2 <- pool(fit_no_gender)
summary(pooled_ests5_2, conf.int = TRUE)

# output
render("ida3.Rmd")

# test
help(par)
help(nhanes)
help(sum)
rowSums(nhanes)
help(mice)
#1
data <- boys[, c("age", "hgt", "wgt", "hc", "reg")]
imp <- mice(data, print = FALSE, seed = 71712)
long <- mice::complete(imp, "long", include = TRUE)
long$whr <- with(long, 100 * wgt / hgt)
imp.itt <- as.mids(long)
fits <- with(imp, lm(y ~ x1 + x2 + x1x2))
ests <- pool(fits)
beta <- summary(ests, conf.int = TRUE)[, c(2, 7, 8)]
#2
data$whr <- 100 * data$wgt / data$hgt
imp.jav1 <- mice(data, seed = 32093, print = FALSE)