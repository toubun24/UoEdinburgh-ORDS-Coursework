library(plotly)
library(dplyr)

setwd("E:/OneDrive/ORDS2/Dissertation/Codes")

data1 <- read.csv("data1.csv")
data2 <- read.csv("data2.csv")
data3 <- read.csv("data3.csv")
data4 <- read.csv("data4.csv")

fig1 <- data1 %>% plot_ly(x = ~Assets, y = ~Weights, type = 'bar', color = ~Methods, colors = c('#845EC2', '#F9F871', '#FFC75F', '#FF9671', '#FF6F91', '#D65DB1'))
fig2 <- data2 %>% plot_ly(x = ~Assets, y = ~Weights, type = 'bar', color = ~Methods, colors = c('#845EC2', '#F9F871', '#FFC75F', '#FF9671', '#FF6F91', '#D65DB1'), showlegend = FALSE)
fig3 <- data3 %>% plot_ly(x = ~Assets, y = ~Weights, type = 'bar', color = ~Methods, colors = c('#845EC2', '#F9F871', '#FFC75F', '#FF9671', '#FF6F91', '#D65DB1'))
fig4 <- data4 %>% plot_ly(x = ~Assets, y = ~Weights, type = 'bar', color = ~Methods, colors = c('#845EC2', '#F9F871', '#FFC75F', '#FF9671', '#FF6F91', '#D65DB1'), showlegend = FALSE)

fig12 <- subplot(fig1, fig2, shareY = TRUE, titleX = TRUE) %>% layout(width = 800, height = 400)
fig34 <- subplot(fig3, fig4, shareY = TRUE, titleX = TRUE) %>% layout(width = 800, height = 400)

fig12
fig34

orca(fig12, "fig12.eps")
orca(fig34, "fig34.eps")