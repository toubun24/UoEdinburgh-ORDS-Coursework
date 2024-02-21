library(rmarkdown)
library(maxLik)
setwd("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex2(2).Rdata")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex4(2).Rdata")
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex5(1).Rdata")
load("C:/Users/Surface/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex2(2).Rdata")
# 2
# b
log_like_norm <- function(X, R, mu, sigma = 1.5)
{
  sum(R*dnorm(x = X, mean = mu, sd = sigma, log = TRUE) 
      + (1-R)*pnorm(X, mean = mu, sd = sigma, log.p = TRUE))
}
mle_2b <- maxLik(logLik = log_like_norm, X = dataex2$X, R = dataex2$R, sigma = 1.5, 
                 start = mean(dataex2$X))
summary(mle_2b)

# 4
ind_mis <- which(is.na(dataex4$Y))
X <- c(dataex4$X[-ind_mis],dataex4$X[ind_mis])
Y_obs <- dataex4$Y[-ind_mis]
m_obs <- length(Y_obs)
n <- length(X)

Q <- function(X, Y_obs, beta01, m_obs, n)
{
  sum(Y_obs*(rep(beta01[1],m_obs)+X[1:m_obs]*beta01[2]))-sum(log(1+exp(beta01[1]+
      X*beta01[2])))+sum((beta01[1]+X[(m_obs+1):n]*beta01[2])*exp(beta01[1]+
      X[(m_obs+1):n]*beta01[2])/(1+exp(beta01[1]+X[(m_obs+1):n]*beta01[2])))
}

mle_4 <- maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, start = c(1,1))
summary(mle_4)

# 5
# b
EM_mixture <- function(y, theta0, eps){
  n <- length(y)
  theta <- theta0
  p <- theta[1]
  mu <- theta[2]; sigma <- theta[3]; lambda <- theta[4]
  diff <- 1
  while(diff > eps){
    theta.old <- theta
    #E-step
    ptilde1 <- p * dlnorm(y, meanlog = mu, sdlog = sigma)
    ptilde2 <- (1 - p) * dexp(y, rate = lambda)
    ptilde <- ptilde1 / (ptilde1 + ptilde2)
    #M-step
    p <- mean(ptilde)
    mu <- sum(log(y) * ptilde) / sum(ptilde)
    sigma <- sqrt(sum(((log(y) - mu)^2) * ptilde) / sum(ptilde))
    lambda <- sum(1 - ptilde) / sum((1 - ptilde) * y)
    theta <- c(p, mu, sigma, lambda)
    diff <- sum(abs(theta - theta.old))
  }
  return(theta)
}

res <- EM_mixture(y = dataex5, c(0.1, 1, 0.5, 2), 0.00001)
p <- res[1]
mu <- res[2]
sigma <- res[3]
lambda <- res[4]
p; mu; sigma; lambda

hist(dataex5, main = "Dataex5", xlab = "Value", ylab = "Density", freq = F, breaks = 40)
curve(p*dlnorm(x, mu, sigma) + (1 - p)*dexp(x, lambda),
      add = TRUE, lwd = 2, col = "blue2")

hist(dataex5[which(dataex5<30)], main = "Dataex5", xlab = "Value", ylab = "Density", xlim=c(0, 30), freq = F, breaks = 40)
curve(p*dlnorm(x, mu, sigma) + (1 - p)*dexp(x, lambda),
      add = TRUE, lwd = 2, col = "blue2")

# output
render("ida2.Rmd")

# test
help(hist)
help(maxLik)
set.seed(1)
n <- 10
y <- rcauchy(n, location = 0, scale = 1)
y
theta=1
dcauchy(y, location = theta, scale = 1, log = TRUE)
help(dcauchy)
help(dnorm)
xx=dataex2$X[1:10]
rr=dataex2$R[1:10]
xx*rr
rr*dnorm(x=xx, mean=0, sd=2, log=TRUE)
help(dnorm)
x=c(1,2,3,4,5)
t=2
x[t+1:4]
x*x/x
help(optim)
fr <- function(x) {   ## Rosenbrock Banana function
  x1 <- x[1]
  x2 <- x[2]
  100 * (x2 - x1 * x1)^2 + (1 - x1)^2
}
optim(c(-1.2,1), fr)
loglik <- function(param) {
  # param: vector of 2, c(mean, standard deviation)
  mu <- param[1]
  sigma <- param[2]
  ll <- -0.5*N*log(2*pi) - N*log(sigma) - sum(0.5*(x - mu)^2/sigma^2)
  # can use dnorm(x, mu, sigma, log=TRUE) instead
  ll
}
x <- rnorm(100, 1, 2) # use mean=1, stdd=2
N <- length(x)
res <- maxLik(loglik, start=c(0,1)) # use 'wrong' start values
summary(res)
warnings()
rep(1,10)
help(dlnorm)
dlnorm(1, meanlog = 0, sdlog = 2)*2
dnorm(0)
dnorm(x, mu1, sigma1)
###
Y_obs=c(0,1,0,1)
X=c(0.5,0.10,0.15,0.2,0.1,0.09,0.08)
beta01=c(2,3)
m_obs=4
n=7
q1=sum(Y_obs*(rep(beta01[1],m_obs)+X[1:m_obs]*beta01[2]))-sum(log(1+exp(beta01[1]+
X*beta01[2])))+sum((beta01[1]+X[(m_obs+1):n]*beta01[2])*exp(beta01[1]+
X[(m_obs+1):n]*beta01[2])/(1+exp(beta01[1]+X[(m_obs+1):n]*beta01[2])))
p <- function(b01,x)
{
  ee=exp(b01[1]+b01[2]*x)
  return(ee/(1+ee))
}
pp=c(p(beta01,X))
pp
q2=sum(Y_obs*log(pp[1:m_obs]))+sum((1-Y_obs)*log(1-pp[1:m_obs]))+sum(log(pp[(m_obs+1):n])*pp[(m_obs+1):n])+sum(log(1-pp[(m_obs+1):n])*(1-pp[(m_obs+1):n]))
q1;q2
help(maxLik)
##
ind_mis <- which(is.na(dataex4$Y))
X <- c(dataex4$X[-ind_mis],dataex4$X[ind_mis])
Y_obs <- dataex4$Y[-ind_mis]
m_obs <- length(Y_obs)
n <- length(X)
Q <- function(X, Y_obs, beta01, m_obs, n)
{
  sum(Y_obs*(rep(beta01[1],m_obs)+X[1:m_obs]*beta01[2]))-sum(log(1+exp(beta01[1]+
  X*beta01[2])))+sum((beta01[1]+X[(m_obs+1):n]*beta01[2])*exp(beta01[1]+
  X[(m_obs+1):n]*beta01[2])/(1+exp(beta01[1]+X[(m_obs+1):n]*beta01[2])))
}

diff <- 1
eps <- 0.00001
beta01 <- c(1,1)
while(diff > eps)
{
  beta01_new <- maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, 
                       start = beta01, iterlim = 1)$estimate
  q <- maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, 
         start = beta01, iterlim = 1)$logLik
  print(q)
  print("1")
  diff <- sum(abs(beta01_new-beta01))
  beta01 <- beta01_new
}
beta01
maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, 
       start = beta01, iterlim = 1)
#
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex4(2).Rdata")
ind_mis <- which(is.na(dataex4$Y))
X <- c(dataex4$X[-ind_mis],dataex4$X[ind_mis])
Y_obs <- dataex4$Y[-ind_mis]
m_obs <- length(Y_obs)
n <- length(X)
diff <- 1
eps <- 0.00001
beta01_t_new <- c(1,1)
p <- function(b01,x)
{
  ee=exp(b01[1]+b01[2]*x)
  return(ee/(1+ee))
}
Q2 <- function(X, Y_obs, beta01, beta01_t, m_obs, n)
{
  pp=p(beta01,X)
  pp_t=p(beta01_t,X[(m_obs+1):n])
  Q2=sum(Y_obs*log(pp[1:m_obs]))+sum((1-Y_obs)*log(1-pp[1:m_obs]))+sum(log(pp[(m_obs+1):n])*pp_t)+sum(log(1-pp[(m_obs+1):n])*(1-pp_t))
  return(Q2)
}
while(diff > eps)
{
  beta01_t_new2 <- maxLik(logLik = Q2, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, beta01 = beta01_t_new,
                       start = beta01_t_new, iterlim = 1)$estimate
  diff <- sum(abs(beta01_t_new2-beta01_t_new))
  beta01_t_new <- beta01_t_new2
}
beta01_t_new
##
maxLik(logLik = Q2, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, beta01 = beta01_t,
       start = beta01_t, iterlim = 1)
#########
load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 2/dataex4(2).Rdata")
ind_mis <- which(is.na(dataex4$Y))
X <- c(dataex4$X[-ind_mis],dataex4$X[ind_mis])
Y_obs <- dataex4$Y[-ind_mis]
m_obs <- length(Y_obs)
n <- length(X)
diff <- 1
eps <- 0.00001
beta01t_old <- c(1,1)
Q <- function(X, Y_obs, beta01, beta01t, m_obs, n)
{
  sum(Y_obs*(beta01[1]+X[1:m_obs]*beta01[2]))-sum(log(1+exp(beta01[1]+
  X*beta01[2])))+sum((beta01[1]+X[(m_obs+1):n]*beta01[2])*exp(beta01t[1]+
  X[(m_obs+1):n]*beta01t[2])/(1+exp(beta01t[1]+X[(m_obs+1):n]*beta01t[2])))
}
while(diff > eps)
{
  beta01t_new <- maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, 
                        beta01t = beta01t_old, start = beta01t_old, iterlim=1)$estimate
  diff <- sum(abs(beta01t_old-beta01t_new))
  beta01t_old <- beta01t_new
}
beta01t_new


beta01t = c(1,-2.5)
beta01 = c(1,-2.5)
Q(X, Y_obs, beta01, beta01t, m_obs, n)
maxLik(logLik = Q, X = X, Y_obs = Y_obs, m_obs = m_obs, n = n, beta01 = beta01t, start = beta01t)
3+X[(m_obs+1):n]
Q(X, Y_obs, beta01t_old, beta01t_old, m_obs, n)
