library(shiny)
library(ggplot2)

# generate our data
get_data <- function(n) {
  data.frame(u1 = rnorm(n), u2 = rnorm(n))
}

shinyServer(function(input, output, session) {

  dat <- reactiveValues(data=get_data(200))

  observeEvent(input$new + input$n, {
    # generate some new data
    dat$data <- get_data(input$n)
  })

  output$plot <- renderPlot({

    x <- dat$data
    # update to skew normal
    id <- x$u2 > input$skew * x$u1
    x$u1[id] <- (-x$u1[id])

    if (input$graph == "boxplot") {
      g <- ggplot(x, aes(y=u1)) + geom_boxplot() + coord_flip()
    } else if (input$graph == "hist") {
      h <- hist(x$u1)
      g <- ggplot(x, aes(x=u1)) + geom_histogram(fill = 'grey70', bins=15)
    } else if (input$graph == "kde") {
      g <- ggplot(x, aes(x=u1)) + geom_density(fill = 'grey70')
    }
    g + theme_bw() + theme(axis.ticks = element_blank(), axis.text = element_blank(), axis.title = element_blank())
  })

})
