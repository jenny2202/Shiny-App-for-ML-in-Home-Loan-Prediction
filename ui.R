

library(caret)
library(shiny)
library(LiblineaR)
library(readr)
library(ggplot2)
library(tidyverse)
library(magrittr)
library(shiny)
library(shinydashboard)
library(shinythemes) 
library(plotly)


dashboardPage(skin="black",
              dashboardHeader(title=tags$em("Shiny prediction app", style="text-align:center;color:#006600;font-size:100%"),titleWidth = 800),
              
              dashboardSidebar(width = 250,
                               sidebarMenu(
                                 br(),
                                 menuItem(tags$em("Upload Test Data",style="font-size:120%"),icon=icon("upload"),tabName="data"),
                                 menuItem(tags$em("Download Predictions",style="font-size:120%"),icon=icon("download"),tabName="download")
                                 
                                 
                               )
              ),
              
              dashboardBody(
                tabItems(
                  tabItem(tabName="data",
                          
                          
                          br(),
                          br(),
                          br(),
                          br(),
                          tags$h4("With this shiny prediction app, you can upload your data and get back predictions.
                                  The model is Tuned Random Forest that predicts whether a loan profile should be granted or not.
                                  ", style="font-size:150%"),
                          
                          
                          br(),
                          
                          tags$h4("To predict using this model, upload test data in csv format (you can change the code to read other data types) by using the button below.", style="font-size:150%"),
                          
                          tags$h4("Then, go to the", tags$span("Download Predictions",style="color:red"),
                                  tags$span("section in the sidebar to  download the predictions."), style="font-size:150%"),
                          
                          br(),
                          br(),
                          br(),
                          column(width = 4,
                                 fileInput('file1', em('Upload test data in csv format ',style="text-align:center;color:blue;font-size:150%"),multiple = FALSE,
                                           accept=c('.csv')),
                                 
                                 uiOutput("sample_input_data_heading"),
                                 tableOutput("sample_input_data"),
                                 
                                 
                                 br(),
                                 br(),
                                 br(),
                                 br()
                          ),
                          br()
                          
                          ),
                  
                  
                  tabItem(tabName="download",
                          fluidRow(
                            br(),
                            br(),
                            br(),
                            br(),
                            column(width = 8,
                                   tags$h4("After you upload a test dataset, you can download the predictions in csv format by
                                           clicking the button below.", 
                                           style="font-size:200%"),
                                   br(),
                                   br()
                            )),
                          fluidRow(
                            
                            column(width = 7,
                                   downloadButton("downloadData", em('Download Predictions',style="text-align:center;color:blue;font-size:150%")),
                                   plotOutput('plot_predictions')
                            ),
                            column(width = 10,
                                   uiOutput("sample_prediction_heading"),
                                   tableOutput("sample_predictions")
                            )
                            
                          ))
                  )))






















