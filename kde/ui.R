library(shiny)


# logifySlider javascript function
JS.logify <-
  "
// function to logify a sliderInput
function logifySlider (sliderId, sci = false) {
  if (sci) {
    // scientific style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return ('10<sup>'+num+'</sup>'); }
    })
  } else {
    // regular number style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return (Math.round((Math.pow(10, num) + Number.EPSILON) * 100) / 100); }
    })
  }
}"

# call logifySlider for each relevant sliderInput
JS.onload <-
  "
// execute upon document loading
$(document).ready(function() {
  // wait a few ms to allow other scripts to execute
  setTimeout(function() {
    // include call for each slider
    logifySlider('adjust', sci = false)
  }, 5)})
"

shinyUI(fluidPage(
  tags$head(tags$script(HTML(JS.logify))),
  tags$head(tags$script(HTML(JS.onload))),
  fluidRow(
    column(width=8, plotOutput("plot")),
    column(width=4, wellPanel(
      sliderInput("adjust", label="Bandwidth adjustment", min=-1, max=1, value=0, step=0.05),
      actionButton("dist", "New Distribution"),
      actionButton("new", "New Sample")
    ))
  )
))
