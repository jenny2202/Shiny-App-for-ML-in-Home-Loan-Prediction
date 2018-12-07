

library(caret)
library(shiny)
library(LiblineaR)
library(readr)
library(ggplot2)
library(tidyverse)
library(magrittr)
library(shinydashboard)
library(shinythemes)
library(plotly)

load("RandomForestTuned.rda")

shinyServer(function(input, output) {
  
  options(shiny.maxRequestSize = 800*1024^2)   # This is a number which specifies the maximum web request size, 
  # which serves as a size limit for file uploads. 
  # If unset, the maximum request size defaults to 5MB.
  # The value I have put here is 80MB
  
  
  output$sample_input_data_heading = renderUI({   # show only if data has been uploaded
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      tags$h4('Sample data')
    }
  })
  
  output$sample_input_data = renderTable({    # show sample of uploaded data
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
      
      colnames(input_data) = c("LOAN", "MORTDUE", "VALUE",
                               "REASON", "JOB", "YOJ",
                               "DEROG", "DELINQ", "CLAGE",
                               "NINQ", "CLNO", "DEBTINC")
      
      head(input_data)
    }
  })
  
  
  
 predictions<-reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      withProgress(message = 'Predictions in progress. Please wait ...', {
        input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        
        colnames(input_data) = c("LOAN", "MORTDUE", "VALUE",
                                 "REASON", "JOB", "YOJ",
                                 "DEROG", "DELINQ", "CLAGE",
                                 "NINQ", "CLNO", "DEBTINC")

        prediction <- predict(my_rf, input_data , type = "prob") %>%  
        pull(BAD)
        
        prediction <- case_when(prediction >= 0.3 ~ "BAD", # this threshold being choosen from Model selection files
                             prediction < 0.3 ~ "GOOD")
        
        input_data_with_prediction = cbind(input_data,prediction )
        input_data_with_prediction 
        
      })
      
    }
  })
 
  output$sample_prediction_heading = renderUI({  # show only if data has been uploaded
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      tags$h4('Sample predictions')
    }
  })
  
  
  output$sample_predictions = renderTable({   # the last 6 rows to show
    pred = predictions()
    head(pred)
    
  })
  
# Visualisation  
  
  output$plot_predictions = renderPlot({   # the last 6 rows to show
    pred = predictions()
    cols <- c("BAD" = "yellow","GOOD" = "gray")
    ggplot(pred, aes(x = LOAN, y = DEBTINC, color = factor(prediction))) + geom_point(size = 4, shape = 19, alpha = 0.7) +
      scale_colour_manual(values = cols,labels = c("BAD", "GOOD"), name= "Home Loan Grant")
    
    
  })
  
   
  
  
  # Downloadable csv of predictions ----
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("input_data_with_predictions", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(predictions(), file, row.names = FALSE)
    })
  

})
