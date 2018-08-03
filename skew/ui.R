library(shiny)

shinyUI(fluidPage(
  includeScript('slider_labels.js'),
  fluidRow(
    column(width=8, plotOutput("plot")),
    column(width=4, wellPanel(
      sliderInput("skew", label="Skewness", min=-10, max=10, value=0, step=0.5, ticks=FALSE),
      selectInput("graph", label="Graph type", choices=c("Boxplot" = 'boxplot', "Histogram" = 'hist', "Kernel Density" = 'kde')),
      sliderInput("n", label="Sample size", min=20, max=1000, value=200),
      actionButton("new", "New Dataset")
    ))
  )
))
