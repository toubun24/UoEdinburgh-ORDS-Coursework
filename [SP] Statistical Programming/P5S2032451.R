# Xiao Heng s2032451
# In this code, I implement the Bayesian inference on Covid-19 incidence in England from infection to death cases.
# To implement the MCMC process, 'rjags' is introduced, which means 'Just Another Gibbs Sampler'.
# With observed 'y' (deaths), I add 20 days of 0 in the beginning of data, the chain from 'x' to 'y' is established in 'model.jags' with prior distribution
# Then, obtaining the jags model, we set proper parameter including 'iteration', 'burn-in', and so on to sample repeatly
# Finally, we get posterior mean and adapt it as prediction of 'y' (death)

library(rmarkdown) # I choose to print the pdf by 'rmarkdown' rather than adapt package 'ggplot', hope this doesn't matter~
library(coda)
library(rjags)

# setwd("C:/Users/DELL-HY/OneDrive/ORDS/Statistical Programming/Selfwork2") # no submit

# data preprocessing
y0 <- rep(0,20) # 20 days with 0 death added in the beginning
y <- c(1,2,0,2,2,0,4,4,1,9,14,20,22,27,40,46,66,63,105,103,149,159,204,263,326,353,360,437,498,576,645,647,
       700,778,743,727,813,900,792,740,779,718,699,646,686,639,610,571,524,566,486,502,451,438,386,380,345,341,
       325,313,306,268,251,259,252,266,256,215,203,196,166,183,162,180,172,167,138,160,144,153,150,122,128,116,
       133,139,122,124,117,92,83,94,109,111,83,86,83,80,73,69) # dataset of death for 100 days
y <- append(y0,y) # data combination
n <- length(y) # length calculate to prevent repeating computation
B <- matrix(0,nrow=n,ncol=n) # matrix about duration from infection to death
for(i in 1:n){
  for(j in 1:i){
    B[i,j] <- dlnorm(i-j,meanlog=3.235,sdlog=0.4147) # positive when i>j, otherwise 0
  }
}

# modelling
mod <- jags.model("model.jags",data=list(y=y,B=B,N=length(y))) # input 'y', 'B' and 'N'
sam.coda <- coda.samples(mod,c("m","n"),n.iter=10000) # iteration of 10000, focus on 'm' and 'n'

# Diagnostic Analysis: (the same in the markdown PDF)

# Considering the initialization iteration of 10000 without burn-in
# Check the maximum of effectiveSize() which indicates the proper effective selection of sample size is about 400 to 600
# Hence to set the 'iteration' to around 1000 or even slightly less is reasonable.

# Then, by checking the trace plots, since just considering around 1000 iterations,
# the first 200 or 300 samples are not stable enough, so a 'burn-in' of around 200 or 300 may be reasonable.

# function for the final plot
finalplot <- function()
{
  startdate <- julian(as.Date("2020-3-2"),origin=as.Date("2019-12-31"))[[1]] # the highest
  specialdate <- julian(as.Date("2020-3-24"),origin=as.Date("2019-12-31"))[[1]]
  timeperiod <- c((startdate-20):(startdate+79))
  interval <- HPDinterval(sam.coda[[1]])
  plot(x=timeperiod,y=interval[121:220,2],lty=2,xlab="2020 date",type="l",ylab="number of infection / death")
  lines(x=timeperiod,y=colMeans(sam.coda[[1]][,121:220]),type="l")
  lines(x=timeperiod,y=colMeans(sam.coda[[1]][,1:100]))
  lines(x=timeperiod,y=interval[121:220,1],lty=2)
  lines(x=timeperiod,y=y[1:100],col="red",type="b",pch=1,cex=1)
  abline(v=specialdate,col="red",lty=2)
  text(x=c(45,45,85,95,110), y=c(1500,1300,1500,1100,750), pos=4, labels=c('new infections (n)', 'with 95% CI', 'Lockdown (24th March)','deaths','predicted deaths (m)'))
}
finalplot()

render("P5S2032451.Rmd") # diagnostic and final plots output
