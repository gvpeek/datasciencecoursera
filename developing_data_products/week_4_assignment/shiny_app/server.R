#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(plotly)

gender_development <- read.csv("data/gender_development.csv")

gender_development$Life.Expectancy.at.Birth..Female. <- as.numeric(gender_development$Life.Expectancy.at.Birth..Female.)
gender_development$Expected.Years.of.Education..Female. <- as.numeric(gender_development$Expected.Years.of.Education..Female.)
gender_development$Estimated.Gross.National.Income.per.Capita..Female. <- as.numeric(gender_development$Estimated.Gross.National.Income.per.Capita..Female.)
gender_development$Life.Expectancy.at.Birth..Male. <- as.numeric(gender_development$Life.Expectancy.at.Birth..Male.)
gender_development$Expected.Years.of.Education..Male. <- as.numeric(gender_development$Expected.Years.of.Education..Male.)
gender_development$Estimated.Gross.National.Income.per.Capita..Male. <- as.numeric(gender_development$Estimated.Gross.National.Income.per.Capita..Male.)
gender_development <- mutate(gender_development, 
                             Income.Gap = Estimated.Gross.National.Income.per.Capita..Female. - Estimated.Gross.National.Income.per.Capita..Male.,
                             Life.Span.Gap = Life.Expectancy.at.Birth..Female. - Life.Expectancy.at.Birth..Male.)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        gender_development_filtered <- reactive ({
                incomeGapInput <- input$sliderIncomeGap
                gender_development <- gender_development[gender_development$Income.Gap >= incomeGapInput[1] & gender_development$Income.Gap <= incomeGapInput[2],]
                lifeSpanGapInput <- input$sliderLifeSpanGap
                gender_development <- gender_development[gender_development$Life.Span.Gap >= lifeSpanGapInput[1] & gender_development$Life.Span.Gap <= lifeSpanGapInput[2],]
        })
        
        useModels <- reactive ({
                incomeGapInput <- input$sliderIncomeGap
                lifeSpanGapInput <- input$sliderLifeSpanGap
                incomeGapInput[1] == -166 & incomeGapInput[2] == 136 & lifeSpanGapInput[1] == -37 & lifeSpanGapInput[2] == 24
        })
        
        modelF <- reactive({
                lm(Life.Expectancy.at.Birth..Female. ~ Estimated.Gross.National.Income.per.Capita..Female., data = gender_development_filtered())
        })
        
        modelM <- reactive({
                lm(Life.Expectancy.at.Birth..Male. ~ Estimated.Gross.National.Income.per.Capita..Male., data = gender_development_filtered())
        }) 
        
        modelFpred <- reactive({
                gniInput <- input$sliderGNI
                predict(modelF(), newdata = data.frame(Estimated.Gross.National.Income.per.Capita..Female. = gniInput))
        })
        modelMpred <- reactive({
                gniInput <- input$sliderGNI
                predict(modelM(), newdata = data.frame(Estimated.Gross.National.Income.per.Capita..Male. = gniInput))
        })

        output$plot1 <- renderPlotly({
                gniInput <- input$sliderGNI
                
                p <- plot_ly(gender_development_filtered(),
                             type = "scatter",
                             text = gender_development_filtered()$Country,
                             x = ~Estimated.Gross.National.Income.per.Capita..Male.,
                             y = ~Life.Expectancy.at.Birth..Male.,
                             name = "Male",
                             marker = list(color = "red"),
                             symbol = 15) %>%
                        add_markers(x = ~Estimated.Gross.National.Income.per.Capita..Female.,
                                    y = ~Life.Expectancy.at.Birth..Female.,
                                    name = "Female",
                                    marker = list(color = "blue"),
                                    symbol = 16)
                if(useModels()) {
                        p <- add_trace(p, 
                                       x = ~Estimated.Gross.National.Income.per.Capita..Male., 
                                       y = fitted(modelM()), 
                                       mode = "lines", 
                                       line = list(width = 1, color = "red"), 
                                       marker = list(size = 1),
                                       text = NULL, 
                                       name = "Male") %>%
                                add_markers(x = ~gniInput, 
                                            y = ~modelMpred(), 
                                            marker = list(color = "red", size = 18),
                                            symbol = 15,
                                            showlegend = FALSE)
                }
                if(useModels()) {
                        p <- add_trace(p, 
                                       x = ~Estimated.Gross.National.Income.per.Capita..Female., 
                                       y = fitted(modelF()), 
                                       mode = "lines", 
                                       line = list(width = 2, color = "blue"), 
                                       text = NULL, 
                                       marker = list(size = 1), 
                                       name = "Female") %>%
                                add_markers(x = ~gniInput, 
                                            y = ~modelFpred(), 
                                            marker = list(color = "blue", size = 18),
                                            symbol = 15,
                                            showlegend = FALSE)
                }
                p <- layout(p,
                            xaxis = list(title = "Estimated Gross National Income Per Capita (thousands of $)"),
                            yaxis = list(title = "Life Expectancy at Birth"))
                p
        })
  output$pred1 <- renderText({
          if(useModels()) {
                  modelFpred()
          } else {
                  "NA"
          }
  })
  output$pred2 <- renderText({
          if(useModels()) {
                  modelMpred()
          } else {
                  "NA"
          }
  })
})
