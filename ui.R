library(shiny)

options(shiny.sanitize.errors = FALSE)
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny application to predict the next word"),
  
  fluidRow(HTML(" <strong>Author: Sanchit Sharma</strong>") ),
  fluidRow(HTML(" <strong>Date: 10-February-2018</strong>") ),
  
  fluidRow(
    br(),
    p("This Shiny application identifies the three most probable words to be the next word of the user defined sentence. The twitter, news and blogs data 
      were combined into a corpus and then cleansed. Data frames of four, three, two and one-grams with corresponding sorted cumulative frequencies were extracted from the corpus. 
      The Shiny app loads the four saved n-gram data frames and applies a simple n-gram back-off algorithm to identify the three most probable words to be the next word of the user defined sentence. ")),
  br(),
  br(),
  
  fluidRow(HTML("<strong>Enter a partial sentence. Press \"Next word\" button to predict the next word</strong>") ),
  fluidRow( p("\n") ),
  
  # Sidebar layout
  sidebarLayout(
    
    sidebarPanel(
      textInput("inputString", "Enter a partial sentence here",value = ""),
      submitButton("Next word")
    ),
    
    mainPanel(
      h4("Predicted Next Word"),
      verbatimTextOutput("prediction"),
      textOutput('text1'),
      textOutput('text2')
    )
  )
    ))