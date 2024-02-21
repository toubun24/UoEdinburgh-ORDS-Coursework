# Xiao HENG s2032451

# OVERVIEW
# HERE WE WRITE 4 FUNCTIONS ABOUT LINEAR REGRESSION
# 1.linmod(formula,dat):
#   By inputing a linear model "formula" as "y~x" and "dat" dataframe, it calculates "beta" and some other related results under "QR Decomposition Method".
# 2.print.linmod(x,...)
#   By inputing linmod class "x", it computes standard error "s.e." and print it with corresponding estimates.
# 3.plot.linmod(x,...)
#   By inputing linmod class "x", it plots a 2-D graph with x-axis "fitted value" and y-axis "residuals".
# 4.predict.linmod(x,newdata)
#   By inputing linmod class "x" and predicting data set "newdata", it preprocesses the data to identify "factors" and corresponding "levels", and the computes "beta*x" to get prediction of y.

linmod <- function(formula,dat)
{
  # name for x and y
  xname <- all.vars(formula)[2:length(all.vars(formula))] # x is located from column 2 to the end
  yname <- all.vars(formula)[1]
  # data for x and y
  x <- model.frame(formula,dat)[xname]
  y <- model.frame(formula,dat)[yname]
  # create list "flev" to indicate the factors and corresponding levels in "x"
  flev=list()
  for(i in 1:(length(xname)))
  {
    if(is.factor(x[[i]])==TRUE) # if column "i" of "x" is "factor", then record in "flev"
    {
      flev <- c(flev, list(levels(x[[i]])))
      names(flev)[length(flev)] <- xname[i]
    }
  }
  if(length(x[1,])==1&is.factor(x[[i]])==FALSE) # in case there is only one column for "model.matrix", which will lead error
  {
    x2 <- data.frame(intercept=rep(1,length(x)),x)
  }else{
    x2 <- model.matrix(formula,dat)
  }
  # QR decomposition
  qrx <- qr(x2)
  Qty <- qr.qty(qrx,as.numeric(unlist(y)))[1:ncol(x2)]
  # beta
  beta <- backsolve(qr.R(qrx),Qty) # backsolve with triangular matrix, which runs faster than solve()
  names(beta) <- colnames(x2)
  # y_hat = beta_hat * X
  mu <- drop(beta%*%t(x2))
  # sigma: the estimated standard deviation of the response (and residuals)
  residual <- y-mu
  RSS <- sum(residual^2)
  DoF <- length(x2[,1])-length(x2[1,])
  sigma <- sqrt(RSS/DoF)
  # V: covariance matrix of the least squares estimators
  qrr <- qr.R(qrx)
  I <- diag(rep(1,length(qrr[1,])))
  rinv <- backsolve(qrr,I)
  V <- rinv%*%t(rinv)*sigma^2
  # combination to output list
  linmod <- list(beta=beta, V=V, mu=mu, y=as.numeric(unlist(y)), yname=yname, formula=formula, flev=flev, sigma=sigma)
  class(linmod) <- "linmod"
  return(linmod)
}

print.linmod <- function(x,...)
{
  se <- sqrt(diag(x$V)) # standard error of estimators
  estimate <- cbind(x$beta,se)
  colnames(estimate) <- c("Estimate","s.e.")
  print(x$formula)
  print(estimate)
}

plot.linmod <- function(x,...)
{
  residual <- x$y-x$mu
  fit <- drop(x$mu) # transfer to normal vector
  plot(x=fit, y=residual,xlab="fitted value", ylab="residuals")
  abline(h=0,lty=2)
}

predict.linmod <- function(x,newdata)
{
  dummy <- rep(1,length(newdata[[1]])) # create dummy variable for response variable in case "model.matrix" can apply correctly
  newdata2 <- data.frame(dummy)
  for(i in 1:length(names(newdata))) # for every column, identify and match with "flev" to find "factors", and factorize them
  {
    if(is.na(match(names(newdata)[i],names(x$flev))))
    {
      newdata2 <- cbind(newdata2, newdata[i]) # not the variable in "flev"
    }else{
      # ensure new factor column has the same levels as before in "flev"
      ftmp <- factor(newdata[[i]],levels=x$flev[[names(newdata)[i]]]) # in case some levels in training data do not appear in predicting data, which will lead error
      newdata2 <- cbind(newdata2, ftmp)
      names(newdata2)[length(newdata2)] <- names(newdata)[i]
    }
  }
  names(newdata2)[1] <- x$yname
  x2 <- model.matrix(formula,newdata2) # the columns are rearranged to follow a-z order now
  prediction <- as.vector(x$beta%*%t(x2)) # y_predict = beta_estimate * x_test
  return(prediction)
}