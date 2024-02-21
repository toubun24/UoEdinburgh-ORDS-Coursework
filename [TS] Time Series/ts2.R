library(rmarkdown)
setwd("E:/OneDrive/ORDS2/[TS] Time Series/Assignments/TS A2")











# output
render("ts2.Rmd")

p0 <- 0.98 ^ 49
p1 <- 0.98
n <- 0
for(i in 1:50)
  n <- n + i * 0.02 * 0.98 ^ (i - 1)
for(i in 1:49)
{
  n <- n + (50 + i) * (i + 1) * 0.02 * p0 * p1
  p1 <- p1 * (0.98 - 0.02 * i)
}
n