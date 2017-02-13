#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
  titlePanel("Predicting Life Expectancy from Per Capita Estimated Gross National Income In Countries of the World"),
  sidebarLayout(
    sidebarPanel(
       h3("Predict"),
       tags$i("Use to predict the Life Expectancy at Birth for a given Estimated Gross National 
              Income amount using a simple linear model, indicated with the fitted lines in the plot. 
              Only valid for default explore values"),
       sliderInput("sliderGNI","Estimated Gross National Income (thousands of $):", 0, 200, value = 50),
       # checkboxInput("showModelF", "Show/Hide Female Prediction", value = TRUE),
       # checkboxInput("showModelM", "Show/Hide Male Prediction", value = TRUE),
       hr(),
       h3("Explore"),
       tags$i("Filter countries based on the width of the gap between males and females in certain categories. 
              These gap scores were calculated as female minus male, so negative values represent 
              countries where females are at a disadvantage to their male counterparts in a given category."),
       sliderInput("sliderIncomeGap","Income Gap (Female - Male):", -166, 136, value = c(-166, 136), dragRange = TRUE),
       sliderInput("sliderLifeSpanGap","Life Span Gap (Female - Male):", -37, 24, value = c(-37, 24), dragRange = TRUE)
    ),
    mainPanel(
       h2("Predicted Life Expectancy"),
       h3("Females:"),
       textOutput("pred1"),
       h3("Males:"),
       textOutput("pred2"),
       h2("Data Points and Predicted Life Expectancy"),
       plotlyOutput("plot1")
    )
  )
))
