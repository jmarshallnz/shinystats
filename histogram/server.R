library(shiny)
library(ggplot2)

# generate our data
get_data <- function(n) {
  n_m <- sample(1:4, 1)
  nn <- as.numeric(rmultinom(1, n, prob=rep(1/n_m, n_m)))
  mu <- rep(rnorm(n_m, sd=3), times=nn)
  r <- rnorm(n) + mu
  data.frame(r=r)
}

shinyServer(function(input, output, session) {

  dat <- reactiveValues(data=get_data(200))

  observeEvent(input$new, {
    # generate some new data
    dat$data <- get_data(200)
  })

  output$plot <- renderPlot({

    ggplot(dat$data) +
      geom_histogram(aes(x=r), bins=input$bins, boundary=input$bin_start, alpha=0.5) +
      scale_x_continuous(expand=c(0,0)) +
      scale_y_continuous(expand=c(0,0,0.05,0)) +
      theme_bw(base_size = 15) +
      labs(x="Data")
  })

})
