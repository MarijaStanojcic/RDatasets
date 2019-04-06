
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

# rdatasets1$Package %>% unique() -> pkgs

# Rdatas$Package %>% unique() -> pkgs

# pkgs <- as.vector(t(pkgs)) # vector of all unique packages 

# install.packages("easypackages")
library(easypackages)


# installed_pkgs <- as.data.frame(installed.packages()) # data frame with all installed packages and 
# some additional information about packages 
# head(installed_pkgs$Package) # preview of a first few installed packages' names


# Installing packages that aren't already installed 
# t_f <- pkgs %in% installed_pkgs$Package # logical vector to see which packages are already installed

# sum(t_f) = length(pkgs) means that all packages are already installed
# if (sum(t_f) != length(pkgs)) install.packages(pkgs[!t_f]) # install packages that aren't already installed

# Loading packages
# loaded_pkgs <- (.packages()) # list of already loaded packages

# loading packages that aren't already loaded 
# suppressPackageStartupMessages(easypackages::libraries(pkgs[!(pkgs %in% loaded_pkgs)]))  
# suppressPackageStartupMessages(easypackages::libraries(pkgs))  
 



# This part is copying on the clipboard all the library(package_name) and then just right click and paste
# paste0("library(", pkgs, ")") %>% clipr::write_clip()


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


double <- duplicated(rdatasets1$Item)

indeks <- vector()
for (i in 1:length(double)){
  if (double[i] == TRUE) 
    indeks <- c(indeks, i) 
}  

multiple_names <- rdatasets1$Item[indeks] 


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



# Define server logic required to draw a histogram
server <- function(input, output, session) {
  

  output$results <- DT::renderDataTable({
    rdatasets1 %>% 
      filter(Rows >= input$n_row_min,
             Rows <= input$n_row_max,
             Cols >= input$n_col_min,
             Cols <= input$n_col_max,
             has_logical %in% input$has_logic,
             has_numeric %in% input$has_num,
             has_binary %in% input$has_bi,
             has_character %in% input$has_char,
             has_factor %in% input$has_factor) -> filtered
    
    DT::datatable(data = filtered)
  })
  
  output$headDT <- renderTable({
    req(input$dataset)
    y <- input$dataset                    # getting the name of data that user wants
    z <- input$package                    # getting the name of package that user wants   
    
    y1 <- y
    
    if (nchar(z) > 0){
      data(list = y, package = z)
      h <- head(eval(as.name(y)))
    } else if(y %in% multiple_names){
      h <- "There is more than one data with that name, please provide a package name as well."
    } else {
      data(list = y)                      # loading the data   
      h <- head(eval(as.name(y)))         # preview of first 6 rows
      rm(list = y1, envir = globalenv())  # removing data from global environment    
     
                                  
    } 
    
    rm(y)                                 # removing y so it doesn't take memory space
    h                                     # returning head() of the data
})
  
  output$summary <- renderPrint({
    req(input$dataset)
    y <- input$dataset                    # getting the name of data that user wants
    z <- input$package
    y1 <- y
    
    if (nchar(z) > 0){
      data(list = y, package = z)
      s <- summary(eval(as.name(y)))
    } else if(y %in% multiple_names){
      s <- "Please provide package name."
    } else {
      data(list = y)                      # loading the data   
      s <- summary(eval(as.name(y)))      # summary of the data saved in s
      rm(list = y1, envir = globalenv())  # removing data from global environment 
      
                                  
    } 
    
    rm(y)                                 # removing y so it doesn't take memory space
    s                                     # return summary
    
  })
  
  output$preview <- renderText({
    req(input$dataset)
    "Preview of the data:"
  })
  
  output$summary_text <- renderText({
    req(input$dataset)
    "Summary of the data:"
  })
  
  onStop(function() cat("Session stopped\n"))
  
}




# Run the application 
shinyApp(ui = ui, server = server)

