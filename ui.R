library(shiny)
library(shinythemes)
library(data.table)

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