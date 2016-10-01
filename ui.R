#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Word Predictor"),
  
  # Sidebar ####    
  sidebarLayout(
    
    sidebarPanel(
      
      # Text input
      textInput("text", label = ('Please enter some text'), value = ''),
      
      # Number of words slider input
      sliderInput('slider',
                  'Maximum number of words',
                  min = 0,  max = 100,  value = 5
      )),
    
    # Mainpanel ####
    
    mainPanel(
      # Table output
      
      dataTableOutput('table'),
      wellPanel(
        
        # Link to report
        helpText(a('More information on the app',
                   href='http://rpubs.com/sinhavis/wp', 
                   target = '_blank')
        ),
        
        # Link to repo
        helpText(a('Code repository',
                   href='https://github.com/',
                   target = '_blank')
        )
      )
    ) 
  )
)
)
