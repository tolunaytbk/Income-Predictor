# Libraries
library(shiny)
library(shinythemes)
library(data.table)
library(MASS)
library(erer)

# Read in the RF model
model <- readRDS("model.rds")

# Get Data
data <- read.csv("GelirSira.csv")
data <- data[-1]

####################################
# User interface                   #
###################################

ui <- fluidPage(theme = shinytheme("superhero"),
  
  # Page header
  headerPanel('Income Level Predictor'),
  
  # Input values
       sidebarPanel(h3("Parameters"),
                sliderInput("Cinsiyet", "Gender:",
                            min = 0, max = 1,
                            value = 1,
                            step = 1),
                sliderInput("OkulTipi", "School Type:",
                            min = 0, max = 1,
                            value = 1, 
                            step = 1),
                sliderInput("Edebiyat", "Letters Grade:",
                            min = 0, max = 100,
                            value = mean(data$Edebiyat),
                            step = 0.5),
                sliderInput("Matematik", "Math Grade:",
                            min = 0, max = 100,
                            value = mean(data$Matematik),
                            step = 0.5),
                sliderInput("FenBil", "Science Grade:",
                            min = 0, max = 100,
                            value = mean(data$FenBil),
                            step = 0.5),
                sliderInput("Tarih", "History Grade:",
                            min = 0, max = 100,
                            value = mean(data$Tarih),
                            step = 0.5),
                
                actionButton("submitbutton", "Submit", class = "btn-danger")
    ),
    
  mainPanel(
      tags$label(h3('Results')), # Status/Output Text Box
      verbatimTextOutput('contents'),
      tags$label(h4('Prediction')),
      tableOutput('tabledata'), # Prediction results table
      tags$label(h4('Coefficients and p-values')),
      tableOutput('coeff'),
      tags$label(h4('Odds Ratios')),
      tableOutput('odds'),
      tags$label(h4('Marginal Effects')),
      tableOutput('m_effect'),
      tags$label(h4('Predicted Probabilities at Mean Levels of Variables')),
      tableOutput('meanpp')
      
      
    )
  )
  
  
  ####################################
  # Server                           #
  ####################################
  
  server<- function(input, output, session) {
    
    # Input Data
    datasetInput <- reactive({  
      new_data <- data.frame(
        Edebiyat  = input$Edebiyat,
        Matematik = input$Matematik,
        FenBil    = input$FenBil,
        Tarih     = input$Tarih,
        Cinsiyet  = input$Cinsiyet,
        OkulTipi  = input$OkulTipi)
      
      #Edebiyat, Matematik, and FenBİl variables are at their means.
      #Value of Cinsiyet and OkulTipi variables is 1.
      
      new_data[, c("Predicted Income Level")] <- predict(model, 
                                            newdata=new_data, 
                                            type="class")
      output <- new_data
      output
    })
    
    # Status/Output Text Box
    output$contents <- renderPrint({
      if (input$submitbutton>0) { 
        isolate("Calculation complete.") 
      } else {
        return("Server is ready for calculation.")
      }
    })
    

    # Coefficients and p-values
    coefficients <- data.frame(coef(summary(model)))
    coefficients$p.value = round((pnorm(abs(coefficients$t.value), 
                                        lower.tail = FALSE) * 2),2)
    
    var_coeff <- data.frame(
      Variable = c("Cinsiyet", "OkulTipi", "Edebiyat", 
                   "Matematik", "FenBil", "Tarih", "1/2", "2/3")
    )
    
    coeff <- data.frame(var_coeff, coefficients)
    
    output$coeff <- renderTable({
      if (input$submitbutton>0) { 
        isolate(coeff)
      } 
    })
    
    # Odds Ratios
    odds_r <- exp(coef(model))
    
    # Percent Odds Ratios
    odds_r_p <- (exp(coef(model))-1)*100

    var <- data.frame(
      Variable = c("Cinsiyet", "OkulTipi", "Edebiyat", 
                   "Matematik", "FenBil", "Tarih")
    )
    
    odds <- data.frame(
       "Variables"          = var,
       "Odds Ratio"         = odds_r,
       "Percent Odds Ratio" = odds_r_p
    )
    
    output$odds <- renderTable({
      if (input$submitbutton>0) { 
        isolate(odds) 
      } 
    })
    
    # Marginal Effect
    m_effect <- ocME(model)
    m_effect$out
    
    me <- data.frame(var,m_effect$out)
    
    output$m_effect <- renderTable({
      if (input$submitbutton>0) { 
        isolate(me) 
      } 
    })
    
    # Mean Predicted Probabilities
    predicted <- predict(model, type = "probs")

    mean_pp <- data.frame("Low" = c(mean(predicted[,1])),
                          "Medium" = c(mean(predicted[,2])),
                          "High" = c(mean(predicted[,3])))
    
    output$meanpp <- renderTable({
      if (input$submitbutton>0) { 
        isolate(mean_pp) 
      } 
    })
    
    # Prediction results table
    output$tabledata <- renderTable({
      if (input$submitbutton>0) { 
        isolate(datasetInput()) 
      } 
    })
    
  }
  
  ####################################
  # Create the shiny app             #
  ####################################
  shinyApp(ui = ui, server = server)
  