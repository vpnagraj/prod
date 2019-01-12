library(shiny)

ui <- fluidPage(
  shinyjs::useShinyjs(),
   titlePanel("PROD"),
   
    mainPanel(
        sliderInput("duration", "Duration (minutes)", min = 1, max = 60, value = 15),
        actionButton("start", "Start"),
        actionButton("stop", "Stop"),
        actionButton("reset", "Reset")
        htmlOutput("messages")
      )
   )

server <- function(input, output) {
  
   clock_time <- eventReactive(input$start, {

     dur <- input$duration*60

     while(dur > 0) {
       
       Sys.sleep(0.99)
       
       dur <- dur - 1
       
       mins <- format(floor(dur/60), digits = 2)
       secs <- format(dur %% 60, digits = 2)
         
       message(paste0(mins, ":",secs))
       
     }
     
     message("Time's up!")


   })
   
   
   observeEvent(input$start, {
     
     withCallingHandlers({
       shinyjs::html(id = "messages", html = "")
       # shinyjs::html(id = "gear", html = "<i class='fa fa-4x fa-spin fa-cog'></i>", add = FALSE)
       clock_time()
     },
     message = function(m) {
       shinyjs::html(id = "messages", html = m$message, add = FALSE)
       
     })
     
   })
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

