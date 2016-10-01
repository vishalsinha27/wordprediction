#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
source('predict.R')

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  prediction =  reactive( {
    
    # Get input
    inputText = input$text
    nSuggestion = input$slider
    
    # Predict
    prediction = data.frame("NextWord" = predict(inputText, nSuggestion))
  })
  
  # Output data table ####
  output$table = renderDataTable(prediction(),options = list(paging = FALSE, 
                                                             searching = FALSE)                                           
                                                             )

  

})
