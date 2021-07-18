library(shiny)
library(ggplot2)

n <- 100

# generate our data
get_data <- function(mu) {
  r <- rnorm(length(mu)) + mu
  data.frame(r=r)
}

# generate a distribution
get_dist <- function(n) {
  n_m <- sample(1:4, 1)
  nn <- as.numeric(rmultinom(1, n, prob=rep(1/n_m, n_m)))
  mu <- rep(rnorm(n_m, sd=3), times=nn)
  return(mu)
}

shinyServer(function(input, output, session) {

  dat <- reactiveValues(mu=get_dist(n), data=NULL)
  
  observeEvent(dat$mu, {
    # generate some new data
    dat$data <- get_data(dat$mu)
  })
  observeEvent(input$dist, {
    # generate a new distribution
    dat$mu <- get_dist(n)
  })
  observeEvent(input$new, {
    # generate a new distribution
    dat$data <- get_data(dat$mu)
  })

  output$plot <- renderPlot({

    ggplot(dat$data) +
      geom_density(aes(x=r), adjust=10^input$adjust) +
      geom_rug(aes(x=r)) +
      scale_x_continuous(expand=c(0,0), limits=c(min(dat$mu)-4, max(dat$mu)+4)) +
      scale_y_continuous(expand=c(0,0,0.05,0)) +
      theme_bw(base_size = 15) +
      labs(x="Data")
  })

})
