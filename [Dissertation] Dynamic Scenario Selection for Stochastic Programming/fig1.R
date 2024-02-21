library(R.matlab)
library(plotly)

setwd("E:/OneDrive/ORDS2/Dissertation/Codes")

data0 <- readMat("retm.mat")
data0 <- as.data.frame(data0)
colnames(data0) <- c("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8")

fig0 <- plot_ly(y = c(data0$A1), type = "box", fillcolor = 'darkgray', boxpoints = FALSE, line = list(color = 'dimgray'), name = "A1", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A2), name = "A2", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A3), name = "A3", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A4), name = "A4", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A5), name = "A5", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A6), name = "A6", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A7), name = "A7", showlegend = FALSE)
fig0 <- fig0 %>% add_trace(y = c(data0$A8), name = "A8", showlegend = FALSE)
fig0 <- fig0 %>% layout(xaxis = list(title = 'Assets'), yaxis = list(title = 'Returns'), width = 600, height = 300)

fig0

orca(fig0, "fig0.eps")

mean(data0$A1); mean(data0$A2); mean(data0$A3); mean(data0$A4); mean(data0$A5); mean(data0$A6); mean(data0$A7); mean(data0$A8)
sd(data0$A1); sd(data0$A2); sd(data0$A3); sd(data0$A4); sd(data0$A5); sd(data0$A6); sd(data0$A7); sd(data0$A8)