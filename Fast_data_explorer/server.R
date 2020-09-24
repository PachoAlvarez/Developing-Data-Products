library(shiny)
library(datasets)
library(DT)
library(GGally)
library(HistData)
library(mlbench)
library(tidyverse)

shinyServer(function(input, output) {
    
# #================= 2. DATA ==================================================
    
    # --------- Carga los datos --------------------------------------
    # input$ty_da --->
    # input$file1 --->  
    # input$dsR --->
    #                                                  ---> dataset()
    dataset <- reactive({
        if (input$ty_da == "file") {
            file <- input$file1
            ext  <- tools::file_ext(file$datapath)
                
            req(file)
            validate(need(ext=="csv", "Please upload a csv file"))
                
            read.csv(file$datapath, header=input$header)
        } else {
            switch (input$dsR,
                    "CO2"           = CO2,
                    "diamonds"      = diamonds,
                    "Galton"        = Galton,
                    "iris"          = iris,
                    "mtcars"        = mtcars,
                    "swiss"         = swiss,
                    "ToothGrowth"   = ToothGrowth
            )
        }
    })
    
    # --------- Tabla para explorar los datos ------------------------
    # dataset() --->
    #                                             ---> output$rawData
    output$rawData <- DT::renderDataTable(
        DT::datatable({dataset()},
                      options = list(lengthMenu=list(c( 5,   10,   15,    -1), 
                                                     c('5', '10', '15', 'All')),
                                     pageLength=5), 
                      filter    = "top", 
                      selection = 'multiple',
                      style     = "bootstrap"
    ))
    
    
# #================= 3. VARIABLES =============================================
    
    # --------- Desplega la lista de variables -----------------------
    # --------- para seleccionar y recoge la seleccion ---------------
    # dataset() --->
    #                                            ---> output$sel_Vars
    #                                                 ---> input$vars
    output$sel_Vars <- renderUI({
        varsName <- names(dataset())
        checkboxGroupInput("vars", "Choose variables:", varsName)
    })
    
    
    # --------- Grafica de Correlaciones entre las -------------------
    # --------- variables seleccionadas ------------------------------
    # dataset() --->
    # input$vars --->
    #                                            ---> output$corrPlot
    output$corrPlot <- renderPlot({
        input$ok
        ggpairs(dataset()[, input$vars])
    })
   
     
# #================= 4. EXPLORE ===============================================
    
    # --------- Subset para las variables elegidas -------------------
    # dataset() --->
    # input$vars --->
    #                                                  ---> set_var()
    set_var <- reactive({
        dataset()[, input$vars]
    })
    
    
    # --------- Desplega la lista de variables -----------------------
    # --------- para seleccionar Y, y recoge la seleccion ------------
    # input$vars --->
    #                                           ---> output$sel_Vars2
    #                                                 ---> input$varY
    output$sel_Vars2 <- renderUI({
        selectInput("varY", "Select the dependent variable:", input$vars)
    })
    
    
    # --------- Desplega la lista de variables -----------------------
    # --------- para seleccionar X, y recoge la seleccion ------------
    # input$vars --->
    # input$varY --->
    #                                            ---> output$sel_VarX
    #                                                 ---> input$varX
    output$sel_VarX <- renderUI({
        varsX <- input$vars[input$vars != input$varY]
        selectInput("varX", "Select the independent variable:", varsX)
    })

    
    # --------- Grafica para la var Y --------------------------------
    # set_var() --->
    # input$varY --->
    #                                               ---> output$plotY
    output$plotY <- renderPlot({
        par(mfrow=c(1, 3))
        hist(set_var()[, input$varY], main=input$varY, xlab="")
        boxplot(set_var()[, input$varY], main="")
        qqnorm(set_var()[, input$varY])
    })
    
    
    # --------- Grafica para el modelo  Y ~ X ------------------------
    # set_var() --->
    # input$varY --->
    # input$varX --->
    #                                              ---> output$plotXY
    output$plotXY <- renderPlot({
        modelo <- lm(set_var()[, input$varY] ~ set_var()[, input$varX])
        par(mfrow=c(2,2))
        plot(modelo)
    })
    
})



#=============================================================================
#                  runApp()