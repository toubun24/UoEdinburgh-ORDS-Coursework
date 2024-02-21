library(plotly)

setwd("E:/OneDrive/ORDS2/Dissertation/Codes")

data1 <- read.csv("data1.csv")
data2 <- read.csv("data2.csv")
data3 <- read.csv("data3.csv")
data4 <- read.csv("data4.csv")

fig5 <- plot_ly(data1, x = ~Assets, y = ~Weights, type = "box", showlegend = FALSE, fillcolor = 'darkgray', boxpoints = FALSE, line = list(color = 'dimgray'))
fig6 <- plot_ly(data2, x = ~Assets, y = ~Weights, type = "box", showlegend = FALSE, fillcolor = 'darkgray', boxpoints = FALSE, line = list(color = 'dimgray'))
fig7 <- plot_ly(data3, x = ~Assets, y = ~Weights, type = "box", showlegend = FALSE, fillcolor = 'darkgray', boxpoints = FALSE, line = list(color = 'dimgray'))
fig8 <- plot_ly(data4, x = ~Assets, y = ~Weights, type = "box", showlegend = FALSE, fillcolor = 'darkgray', boxpoints = FALSE, line = list(color = 'dimgray'))

fig56 <- subplot(fig5, fig6, shareY = TRUE, titleX = TRUE) %>% layout(width = 800, height = 400)
fig78 <- subplot(fig7, fig8, shareY = TRUE, titleX = TRUE) %>% layout(width = 800, height = 400)

fig56
fig78

orca(fig56, "fig56.eps")
orca(fig78, "fig78.eps")