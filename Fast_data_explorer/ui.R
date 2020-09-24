 library(shiny)
 library(datasets)
 library(DT)
 library(GGally)
 library(HistData)
 library(mlbench)
 library(tidyverse)

 shinyUI(fluidPage(
         
     titlePanel("FAST DATA EXPLORER"),
     
     tabsetPanel(type = "tabs", 
                 
# #================= 1. INSTRUCTIONS ==========================================
                 tabPanel("1. INSTRUCTIONS", 
                          titlePanel("General INSTRUCTIONS for using this 
                                     application"),
                          
                          h4("This application will allow you to inspect a 
                             database in a fast and agile way. Upload your data
                             file, in .CSV format, or choose from one of the 
                             data sets preloaded for you. And inspect the 
                             relationships between your variables."),
                          
                          h3("TAB 2. Input DATA"),
                          h4("Choose whether to use your own .CSV file 
                          (loaded from somewhere on your machine), or to work
                          with a dataset supplied by R."),
                          hr(),
                          h3("TAB 3. Select VARIABLES"),
                          h4("Select the variables from the file you uploaded,
                          with which you want to do this preliminar exploration"),
                          hr(),
                          h3("TAB 4. EXPLORE relationship between them"),
                          h4("Notice how these variables are related and what 
                             this tells you for your analysis"),
                          hr(),
                          h5("Questions: francisco.alvarez@correounivalle.edu.co")
                          ),
                 
# #================= 2. DATA ==================================================
                 tabPanel("2. DATA", 
                          titlePanel("Select the data. Look at your variables."),
                          
                          sidebarPanel(
                                  titlePanel("Select the data source"),
                                  
                                  radioButtons("ty_da", "Source of data",
                                               c("None"       = "aa",
                                                 "R data set" = "Rds",
                                                 "Your file"  = "file"),
                                              selected = NULL
                                  ),
                                  
                                  conditionalPanel(
                                          condition="input.ty_da == 'Rds'",
                                          radioButtons("dsR", 
                                                       "Choice a Data set", 
                                                       c("Carbon Dioxide Uptake in Grass Plants"="CO2",
                                                         "Diamonds"="diamonds",
                                                         "Galton's parent and child heights"="Galton",
                                                         "Edgar Anderson's Iris data"="iris",
                                                         "Motor trend car road test"="mtcars",
                                                         "Swiss Fertility and Socioeconomic Indicators (1888)"="swiss",
                                                         "The Effect of Vitamin C on Tooth Growth in Guinea Pigs"="ToothGrowth"))
                                  ),
                                  
                                  conditionalPanel(
                                          condition="input.ty_da == 'file'",
                                          fileInput("file1", "Choose CSV File",
                                                    accept=".csv"),
                                          checkboxInput("header", "Header", T)
                                  )
                          ),
                          
                          mainPanel(
                                  titlePanel("Look at the data"),
                                  
                                  conditionalPanel(
                                          condition="input.ty_da != 'aa'",
                                          fluidRow(column(DT::dataTableOutput("rawData"),
                                                          width=12))
                                  )
                          )),
                 
# #================= 3. VARIABLES =============================================
                 tabPanel("3. VARIABLES", 
                          titlePanel("Select the variables you want to 
                                             explore"),
                          
                          sidebarPanel(
                                  titlePanel("Check as many variables as you need"),
                                  
                                  uiOutput("sel_Vars"),
                                  hr(),
                                  checkboxInput("ok_cor", "You want to see the
                                                correlations?", value=F)
                          ),
                          
                          mainPanel(
                                  titlePanel("Observe the correlations between
                                             the variables you selected"),
                                  
                                  conditionalPanel(
                                          condition="input.ok_cor",
                                          plotOutput("corrPlot")
                                  )
                          )),
                 
# #================= 4. EXPLORE ===============================================
                 tabPanel("4. EXPLORE", 
                          titlePanel("Observe the correlations of the variable
                                     Y with the main predictors"),
                          
                          navlistPanel(
                                  tabPanel("Dependent variable",
                                          titlePanel("Choose Y"),
                                          fluidRow(
                                                  column(width=4, 
                                                         uiOutput("sel_Vars2"))
                                                  ),
                                          fluidRow(
                                                  column(12, plotOutput("plotY"))
                                                  )
                                          ),
                                  
                                  tabPanel("One predictor",
                                           titlePanel("Effect of the predictor
                                                      on Y"),
                                           
                                           fluidRow(
                                                   column(width=4,
                                                          uiOutput("sel_VarX"))
                                                   ),
                                           fluidRow(
                                                   column(12, plotOutput("plotXY"))
                                                   )
                                  )
                          ))
                 )
         ))