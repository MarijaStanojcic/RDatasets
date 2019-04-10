# Define server logic required to draw a histogram

rdatasets1 <- read.csv("Rdatas.csv", header = TRUE)

n_row_max <- max(rdatasets1$Rows)
n_col_max <- max(rdatasets1$Cols)


double <- duplicated(rdatasets1$Item)

indeks <- vector()
for (i in 1:length(double)){
  if (double[i] == TRUE) 
    indeks <- c(indeks, i) 
}  

multiple_names <- rdatasets1$Item[indeks] 




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

