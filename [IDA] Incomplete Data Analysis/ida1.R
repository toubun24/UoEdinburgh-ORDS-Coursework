library(rmarkdown)
setwd("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 1")
setwd("C:/Users/Surface/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 1")
Sys.setlocale("LC_TIME", "English")
# 3
# a

# simulating the data
n=500
set.seed(1)
Z1 <- rnorm(n, 0, 1)
Z2 <- rnorm(n, 0, 1)
Z3 <- rnorm(n, 0, 1)
Y1 <- 1+Z1
Y2 <- 5+2*Z1+Z2
# extracting the index associated to the missing values
a_mar <- 2
b_mar <- 0
f_mar <- a_mar*(Y1-1)+b_mar*(Y2-5)+Z3
ind_mar_mis <- which(f_mar < 0)
Y2_MAR_obs <-Y2[-ind_mar_mis]
Y2_MAR_mis <-Y2[ind_mar_mis]
# plot
plot(density(Y2),
     col = "red", ylim = c(0, 0.25), main = "MAR",
     xlab = "Y2", ylab = "Density", lwd = 2)
lines(density(Y2_MAR_obs), col = "blue", lwd = 2)
legend(8.5, 0.23, legend = c("Completed data", "Observed data"),
       col = c("red", "blue"), lty = c(1, 1), bty ="n", lwd = c(2,2))

# b

# construct data.frame
Y2_MAR_na <- rep(NA,n)
ind_mar_obs <- which(f_mar >= 0)
for(i in ind_mar_obs)
  Y2_MAR_na[i] <- Y2[i]
# stochastic regression imputation
data <- data.frame("y1" = Y1, "y2" = Y2_MAR_na)
fit <- lm(y2 ~ y1, data = data)
fit
set.seed(2) #!!!!!!!!!!!!!!!!!1
predicted_Y2 <- predict(fit, newdata = data) + rnorm(n, 0, sigma(fit))
Y2_sri <- ifelse(is.na(Y2_MAR_na), predicted_Y2, Y2_MAR_na)
# scatter plot
plot(x = data$y1, y = data$y2, xlab = "Y1", ylab = "Y2", xlim = c(-3,6),
     ylim = c(-5,13), main = "MAR")
for(i in ind_mar_mis)
  points(x = Y1[i], y = Y2_sri[i], col = "firebrick1")
# distribution plot
plot(density(Y2),
     col = "red", ylim = c(0, 0.25), main = "Stochastic Regression Imputation in MAR",
     xlab = "Y2", ylab = "Density", xlim = c(-6,16), lwd = 2)
lines(density(Y2_MAR_obs), col = "blue", lwd = 2)
lines(density(Y2_sri), col = "darkgreen", lwd = 2)
legend(8.5, 0.23, legend = c("Completed data", "Observed data", "imputed data"),
       col = c("red", "blue", "darkgreen"), lty = c(1, 1, 1), bty ="n", lwd = c(2,2,2))

# c

# extracting the index associated to the missing values
a_mnar <- 0
b_mnar <- 2
f_mnar <- a_mnar*(Y1-1)+b_mnar*(Y2-5)+Z3
ind_mnar_mis <- which(f_mnar < 0)
Y2_MNAR_obs <-Y2[-ind_mnar_mis]
Y2_MNAR_mis <-Y2[ind_mnar_mis]
# plot
plot(density(Y2),
     col = "red", ylim = c(0, 0.32), main = "MNAR",
     xlab = "Y2", ylab = "Density", lwd = 2)
lines(density(Y2_MNAR_obs), col = "blue", lwd = 2)
legend(8, 0.26, legend = c("Completed data", "Observed data"),
       col = c("red", "blue"), lty = c(1, 1), bty ="n", lwd = c(2,2))

# d

# construct data.frame
Y2_MNAR_na <- rep(NA,n)
ind_mnar_obs <- which(f_mnar >= 0)
for(i in ind_mnar_obs)
  Y2_MNAR_na[i] <- Y2[i]
# stochastic regression imputation
data2 <- data.frame("y1" = Y1, "y2" = Y2_MNAR_na)
fit2 <- lm(y2 ~ y1, data = data2)
# summary(fit2)
set.seed(3)
predicted2_Y2 <- predict(fit2, newdata = data2) + rnorm(n, 0, sigma(fit2))
Y2_sri2 <- ifelse(is.na(Y2_MNAR_na), predicted2_Y2, Y2_MNAR_na)
# scatter plot
plot(x = data2$y1, y = data2$y2, xlab = "Y1", ylab = "Y2", xlim = c(-3,6),
     ylim = c(-1,15), main = "MNAR")
for(i in ind_mar_mis)
  points(x = Y1[i], y = Y2_sri2[i], col = "firebrick1")
# distribution plot
plot(density(Y2),
     col = "red", ylim = c(0, 0.3), main = "Stochastic Regression Imputation in MNAR",
     xlab = "Y2", ylab = "Density", xlim = c(-5,15), lwd = 2)
lines(density(Y2_MNAR_obs), col = "blue", lwd = 2)
lines(density(Y2_sri2), col = "darkgreen", lwd = 2)
legend(8, 0.23, legend = c("Completed data", "Observed data", "imputed data"),
       col = c("red", "blue", "darkgreen"), lty = c(1, 1, 1), bty ="n", lwd = c(2,2,2))

# 4
# a

load("E:/OneDrive/ORDS2/[IDA] Incomplete Data Analysis/Assignments/Assignment 1/IDA Assignment 1 databp.Rdata")

# complete case analysis: mean value of recovery time
mean_recovtime_cc <- mean(databp$recovtime, na.rm = TRUE)
mean_recovtime_cc
# complete case analysis: standard error of mean of recovery time
se_recovtime_cc <- sd(databp$recovtime, na.rm = TRUE)/
  sqrt(length(databp$recovtime[-which(is.na(databp$recovtime)==TRUE)]))
se_recovtime_cc
# complete case analysis: pearson correlation between recovery time and dose
cor_rd_cc <- cor(databp$recovtime, databp$logdose, use = "complete")
cor_rd_cc
# complete case analysis: pearson correlation between recovery time and blood pressure
cor_rb_cc <- cor(databp$recovtime, databp$bloodp, use = "complete")
cor_rb_cc

# b

# mean imputation: mean value of recovery time
mean_recovtime_mi <- mean(databp$recovtime, na.rm = TRUE)
mean_recovtime_mi
# mean imputation implementation
recovtime_mi <- databp$recovtime
recovtime_mi[which(is.na(recovtime_mi)==TRUE)] <- mean_recovtime_mi
recovtime_mi[which(is.na(databp$recovtime)==TRUE)]
# mean imputation: standard error of mean of recovery time
se_recovtime_mi <- sd(recovtime_mi)/sqrt(length(recovtime_mi))
se_recovtime_mi
# mean imputation: pearson correlation between recovery time and dose
cor_rd_mi <- cor(recovtime_mi, databp$logdose)
cor_rd_mi
# mean imputation: pearson correlation between recovery time and blood pressure
cor_rb_mi <- cor(recovtime_mi, databp$bloodp)
cor_rb_mi

# c

# mean regression imputation implementation
fit_mri <- lm(recovtime ~ logdose+bloodp, data = databp)
prediction_mri <- predict(fit_mri, newdata = databp)
recovtime_mri <- ifelse(is.na(databp$recovtime), prediction_mri, databp$recovtime)
recovtime_mri[which(is.na(databp$recovtime)==TRUE)]
# mean regression imputation: mean value of recovery time
mean_recovtime_mri <- mean(recovtime_mri)
mean_recovtime_mri
# mean regression imputation: standard error of mean of recovery time
se_recovtime_mri <- sd(recovtime_mri)/sqrt(length(recovtime_mri))
se_recovtime_mri
# mean regression imputation: pearson correlation between recovery time and dose
cor_rd_mri <- cor(recovtime_mri, databp$logdose)
cor_rd_mri
# mean regression imputation: pearson correlation between recovery time and blood pressure
cor_rb_mri <- cor(recovtime_mri, databp$bloodp)
cor_rb_mri

# d

# stochastic regression imputation implementation
set.seed(4)
prediction_sri <- predict(fit_mri, newdata = databp) +
  rnorm(length(databp$recovtime), 0, sigma(fit_mri))
recovtime_sri <- ifelse(is.na(databp$recovtime), prediction_sri, databp$recovtime)
recovtime_sri[which(is.na(databp$recovtime)==TRUE)]
# stochastic regression imputation: mean value of recovery time
mean_recovtime_sri <- mean(recovtime_sri)
mean_recovtime_sri
# stochastic regression imputation: standard error of mean of recovery time
se_recovtime_sri <- sd(recovtime_sri)/sqrt(length(recovtime_sri))
se_recovtime_sri
# stochastic regression imputation: pearson correlation between recovery time and dose
cor_rd_sri <- cor(recovtime_sri, databp$logdose)
cor_rd_sri
# stochastic regression imputation: pearson correlation between recovery time and blood pressure
cor_rb_sri <- cor(recovtime_sri, databp$bloodp)
cor_rb_sri

# e

# predictive mean matching implementation
prediction_pmm <- prediction_mri
y_true <- databp$recovtime[-which(is.na(databp$recovtime)==TRUE)]
for(j in which(is.na(databp$recovtime)==TRUE))
{
  k <- which.min((prediction_pmm[j]-y_true)^2)
  prediction_pmm[j] <- y_true[k]
}
recovtime_pmm <- ifelse(is.na(databp$recovtime), prediction_pmm, databp$recovtime)
recovtime_pmm[which(is.na(databp$recovtime)==TRUE)]
# predictive mean matching: mean value of recovery time
mean_recovtime_pmm <- mean(recovtime_pmm)
mean_recovtime_pmm
# predictive mean matching: standard error of mean of recovery time
se_recovtime_pmm <- sd(recovtime_pmm)/sqrt(length(recovtime_pmm))
se_recovtime_pmm
# predictive mean matching: pearson correlation between recovery time and dose
cor_rd_pmm <- cor(recovtime_pmm, databp$logdose)
cor_rd_pmm
# predictive mean matching: pearson correlation between recovery time and blood pressure
cor_rb_pmm <- cor(recovtime_pmm, databp$bloodp)
cor_rb_pmm

# output
render("ida1.Rmd")
