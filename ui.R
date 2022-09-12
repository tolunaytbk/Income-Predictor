# Libraries
library(shiny)
library(shinythemes)
library(data.table)

# Read in the RF model
model <- readRDS("model.rds")

# Get Data
data <- read.csv("GelirSira.csv")
data <- data[-1]

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
                  tags$label(h4('Marginal Error For All Categories')),
                  tableOutput('meALL'),
                  tags$label(h4('Marginal Error For For 1st Category')),
                  tags$label(h4('ME.1')),
                  tableOutput('me1'),
                  tags$label(h5('Marginal Error For For 2nd Category')),
                  tags$label(h5('ME.2')),
                  tableOutput('me2'),
                  tags$label(h5('Marginal Error For 3rd Category')),
                  tags$label(h5('ME.3')),
                  tableOutput('me3'),
                  tags$label(h4('Predicted Probabilities at Mean Levels of Variables')),
                  tableOutput('meanpp')
                  
                  
                )
)