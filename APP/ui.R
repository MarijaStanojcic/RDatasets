
library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyverse)
library(XML)



cat("Doing application setup\n")
onStop(function() {
  cat("Doing application cleanup\n")
})

 rdatasets1 <- read.csv("Rdatas.csv", header = TRUE)

library(easypackages)


library(boot)
library(carData)
library(cluster)
library(COUNT)
library(DAAG)
library(datasets)
library(drc)
library(Ecdat)
library(evir)
library(forecast)
library(fpp2)
library(gamclass)
library(gap)
library(geepack)
library(ggplot2)
library(HistData)
library(HSAUR)
library(hwde)
library(ISLR)
library(KMsurv)
library(lattice)
library(lme4)
library(lmec)
library(MASS)
library(mediation)
library(mi)
library(mosaicData)
library(multgee)
library(plm)
library(plyr)
library(pscl)
library(psych)
library(quantreg)
library(reshape2)
library(robustbase)
library(rpart)
library(sandwich)
library(sem)
library(Stat2Data)
library(survival)
library(texmex)
library(vcd)
library(Zelig)

n_row_max <- max(rdatasets1$Rows)
n_col_max <- max(rdatasets1$Cols)

#install.packages("shinyWidgets")
library(shinyWidgets)

#
#double <- duplicated(rdatasets1$Item)
#
#indeks <- vector()
#for (i in 1:length(double)){
#  if (double[i] == TRUE) 
#    indeks <- c(indeks, i) 
#}  
#
#multiple_names <- rdatasets1$Item[indeks] 


##################### APP

ui <- fluidPage(
  
  # Application title
  titlePanel("R Datasets", windowTitle = "R Datasets"),
  
  tags$h3("Find R data that you need"),
  br(),
  
  
  fluidRow(
    column(width = 3,
           wellPanel(
             numericInput(inputId = "n_row_min",
                          label = paste0("Minimum number of observations (rows). Enter number between 1 and ", n_row_max),
                          min = 1,
                          max = n_row_max,
                          value = 1,
                          step = 1),
             
             numericInput(inputId = "n_row_max",
                          label = paste0("Maximum number of observations (rows). Enter number between 1 and ", n_row_max),
                          min = 1,
                          max = n_row_max,
                          value = n_row_max,
                          step = 1),
             
             numericInput(inputId = "n_col_min",
                          label = paste0("Minimum number of variables (columns). Enter number between 1 and ", n_col_max),
                          min = 1,
                          max = n_col_max,
                          value = 1, 
                          step = 1),
             
             numericInput(inputId = "n_col_max",
                          label = paste0("Maximum number of variables (columns). Enter number between 1 and ", n_col_max),
                          min = 1,
                          max = n_col_max,
                          value = n_col_max, 
                          step = 1),
             
             checkboxGroupInput(inputId = "has_logic",
                                label = "Data has logical variable/s:",
                                choices = c("TRUE", "FALSE"),
                                selected = c("TRUE", "FALSE")),
             
             checkboxGroupInput(inputId = "has_bi",
                                label = "Data has binary variable/s:",
                                choices = c("TRUE", "FALSE"),
                                selected = c("TRUE", "FALSE")),
             
             checkboxGroupInput(inputId = "has_num",
                                label = "Data has numerical variable/s:",
                                choices = c("TRUE", "FALSE"),
                                selected = c("TRUE", "FALSE")),
             
             checkboxGroupInput(inputId = "has_char",
                                label = "Data has charcter variable/s:",
                                choices = c("TRUE", "FALSE"),
                                selected = c("TRUE", "FALSE")),
             
             checkboxGroupInput(inputId = "has_factor",
                                label = "Data has factor variable/s:",
                                choices = c("TRUE", "FALSE"),
                                selected = c("TRUE", "FALSE"))
             
           )
    ),
    
    column(width = 9,
           DT::dataTableOutput("results")
    )
  ),
  
  fluidRow(
    column(3, 
           wellPanel(textInput(inputId = "dataset",
                               label = h3("Which data would you like to peek at?"))),
           wellPanel(textInput(inputId = "package",
                               label = h3("Package name (optional, but recommended):")))),
    column(9, textOutput("preview"), br(),
           tableOutput("headDT"), br())
  ),
  
  fluidRow(
    column(3,
           br(),
           br(),
           tags$strong("Created by:"),
           br(),
           tags$span(p("Marija Stanojcic"), style = "font-size: 16px"),
           tags$span(p(a(icon("github"), href = "https://github.com/MarijaStanojcic"), "    ",
                       a(icon("linkedin-square"), href = "https://linkedin.com/in/marijastanojcic"), "      ",
                       a(icon("envelope"), href = "mailto:marijast92@gmail.com")),
                     style="font-size: 24px"),
           
           br(),
           tags$span(p("This app uses the next ",
                       a("list", href = "http://vincentarelbundock.github.io/Rdatasets/datasets.html") ," of datasets (with some modifications).")
                     , style = "font-size: 12px")),
    column(9, textOutput("summary_text"), br(), verbatimTextOutput("summary"))
  )
)



