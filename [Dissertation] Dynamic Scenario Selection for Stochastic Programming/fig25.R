library(plotly)

Methods <- c("M1-SP", "M2-KM", "M3-AS", "M4-IR", "M5-IS", "M0-FS")
ST1 <- c(0, 113.76, 0.02, 97.03, 117.80, 0)
OT1 <- c(0.22, 0.25, 0.22, 0.22, 0.23, 119.37)
data1 <- data.frame(Methods, ST1, OT1)
ST2 <- c(0, 1117.44, 0.02, 97.07, 117.82, 0)
OT2 <- c(0.29, 0.30, 0.28, 0.29, 0.30, 119.37)
data2 <- data.frame(Methods, ST2, OT2)
ST3 <- c(0, 1.20, 0.01, 0.51, 0.29, 0)
OT3 <- c(0.29, 0.23, 0.36, 0.24, 0.22, 119.37)
data3 <- data.frame(Methods, ST3, OT3)
ST4 <- c(0, 111.47, 0.00, 1.96, 1.97, 0)
OT4 <- c(1.98, 0.28, 0.90, 0.58, 0.31, 119.37)
data4 <- data.frame(Methods, ST4, OT4)

fig1 <- plot_ly(data1, x = ~Methods, y = ~OT1, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE)
fig1 <- fig1 %>% add_trace(y = ~ST1, name = 'ST', marker = list(color = 'dimgray'))
fig1 <- fig1 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig2 <- plot_ly(data2, x = ~Methods, y = ~OT2, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE)
fig2 <- fig2 %>% add_trace(y = ~ST2, name = 'ST', marker = list(color = 'dimgray'))
fig2 <- fig2 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig3 <- plot_ly(data3, x = ~Methods, y = ~OT3, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE)
fig3 <- fig3 %>% add_trace(y = ~ST3, name = 'ST', marker = list(color = 'dimgray'))
fig3 <- fig3 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig4 <- plot_ly(data4, x = ~Methods, y = ~OT4, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE)
fig4 <- fig4 %>% add_trace(y = ~ST4, name = 'ST', marker = list(color = 'dimgray'))
fig4 <- fig4 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig11 <- plot_ly(data1, x = ~Methods, y = ~OT1, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE) %>% layout(yaxis = list(range = c(0, 1), constrain="domain"))
fig11 <- fig11 %>% add_trace(y = ~ST1, name = 'ST', marker = list(color = 'dimgray'))
fig11 <- fig11 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig22 <- plot_ly(data2, x = ~Methods, y = ~OT2, type = 'bar', name = 'OT', marker = list(color = 'darkgray')) %>% layout(yaxis = list(range = c(0, 1), constrain="domain"))
fig22 <- fig22 %>% add_trace(y = ~ST2, name = 'ST', marker = list(color = 'dimgray'))
fig22 <- fig22 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig33 <- plot_ly(data3, x = ~Methods, y = ~OT3, type = 'bar', name = 'OT', marker = list(color = 'darkgray'), showlegend = FALSE) %>% layout(yaxis = list(range = c(0, 1), constrain="domain"))
fig33 <- fig33 %>% add_trace(y = ~ST3, name = 'ST', marker = list(color = 'dimgray'))
fig33 <- fig33 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
fig44 <- plot_ly(data4, x = ~Methods, y = ~OT4, type = 'bar', name = 'OT', marker = list(color = 'darkgray')) %>% layout(yaxis = list(range = c(0, 1), constrain="domain"))
fig44 <- fig44 %>% add_trace(y = ~ST4, name = 'ST', marker = list(color = 'dimgray'))
fig44 <- fig44 %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')

fig12 <- subplot(fig1, fig2, shareY = TRUE, titleX = TRUE)
fig34 <- subplot(fig3, fig4, shareY = TRUE, titleX = TRUE)
fig122 <- subplot(fig11, fig22, nrows = 2, shareX = TRUE, titleX = TRUE)
fig344 <- subplot(fig33, fig44, nrows = 2, shareX = TRUE, titleX = TRUE)

fig1122 <- subplot(fig12, fig122) %>% layout(yaxis = list(title = 'Time (s)'), width = 800, height = 400)
fig3344 <- subplot(fig34, fig344) %>% layout(yaxis = list(title = 'Time (s)'), width = 800, height = 400)

fig1122
fig3344

orca(fig1122, "fig1122.eps")
orca(fig3344, "fig3344.eps")