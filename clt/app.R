library(shiny)
library(tidyverse)
library(sn)
library(patchwork)
library(broom)

n_samples <- 100

# generate a population with different skewness
gen_pop <- function(skewness) {
  pop = rsn(1000, xi=0, omega=1, alpha=skewness)
  list(pop=pop, from=min(pop), to=max(pop))
}

gen_data <- function(pop, from, to, n_size) {
  population <- density(pop, from=from, to=to) %>% tidy()
  population_mean <- population %>%
    summarise(barx = mean(pop), bary = approx(x=x, y=y, xout=barx)$y)
  samples <- expand_grid(size = n_size, sample = 1:n_samples) %>%
    mutate(data = map(size, ~ sample(pop, .))) %>%
    mutate(barx = map(data, ~ mean(.x))) %>%
    mutate(dens = map(data, ~density(.x, from=from, to=to) %>% tidy())) %>%
    select(-data) %>%
    unnest(cols=c(barx, dens))
  sample_means <- samples %>%
    group_by(sample) %>% summarise(barx = unique(barx), bary = approx(x=x, y=y, xout=barx)$y)
  list(population = population,
       population_mean = population_mean,
       samples = samples,
       sample_means = sample_means)
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("distPlot"),
        width=9
      ),
      sidebarPanel(
            sliderInput("skewness",
                        "Population shape",
                        min = -10,
                        max = 10,
                        value = 0),
            sliderInput("n",
                        "Sample size",
                        min = 10,
                        max = 200,
                        value = 20),
            width = 3
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  popn <- reactive(gen_pop(-input$skewness))
  state <- reactive(gen_data(popn()$pop, popn()$from, popn()$to, input$n))

    output$distPlot <- renderPlot({
      g1 <- ggplot(state()$population) + geom_line(mapping=aes(x=x, y=y)) +
        geom_segment(data=state()$population_mean, aes(x=barx, y=0, xend=barx, yend=bary), col='red') +
        theme_minimal() + theme(axis.title = element_blank(),
                                axis.text = element_blank(),
                                axis.ticks = element_blank()) +
        scale_x_continuous(expand=c(0,0)) +
        scale_y_continuous(expand=c(0,0,0,0.002)) +
        ggtitle("Population")
     
      g2 <- ggplot(state()$samples) + geom_line(mapping=aes(x=x, y=y, group=sample), alpha=0.2) +
        geom_segment(data=state()$sample_means, aes(x=barx, y=0, xend=barx, yend=bary), col='red', alpha=0.2) +
        theme_minimal() + theme(axis.title = element_blank(),
                                axis.text = element_blank(),
                                axis.ticks = element_blank()) +
        scale_x_continuous(expand=c(0,0)) +
        scale_y_continuous(expand=c(0,0,0,0.002)) +
        ggtitle("Samples")
      
      g3b <- ggplot(state()$sample_means) + geom_density(mapping=aes(x=barx), adjust=1.5, fill='red', alpha=0.4, col=NA) +
        scale_x_continuous(limits = c(popn()$from, popn()$to), expand=c(0,0)) +
        scale_y_continuous(expand=c(0,0,0,0.002)) +
        theme_minimal() + theme(axis.title = element_blank(),
                                axis.text = element_blank(),
                                axis.ticks = element_blank()) +
        ggtitle("Distribution of sample means")
      g1/g2/g3b
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
