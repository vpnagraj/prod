library(shiny)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", 
              type = "text/css", 
              href = "style.css"),
    tags$link(
      rel = "stylesheet", 
      href="https://fonts.googleapis.com/css?family=Ubuntu+Mono"
    )
  ),
  shinyjs::useShinyjs(),
    tags$br(),
    fluidRow(
      column(12,
        sliderInput("duration", "TIMER (MINUTES)", min = 1, max = 60, value = 15, width = '100%'),
        tags$div(
          actionButton("start", "START", icon = icon("play"), class = "time-btn"),
          actionButton("pause", "PAUSE", icon = icon("pause"), class = "time-btn"),
          actionButton("reset", "RESET", icon = icon("hourglass-start"), class = "time-btn"),
          class = "buttons"
          ),
        tags$h2(textOutput("countdown"))
      )
      )
   )

server <- function(input, output,session) {
  
  # observers for actionbuttons
  observeEvent(input$start, {active(TRUE); shinyjs::disable("duration")})
  observeEvent(input$pause, {active(FALSE); shinyjs::enable("duration")})
  observeEvent(input$reset, {timer(input$duration*60)})
  
  # Initialize the timer, 10 seconds, not active.
  timer <- reactiveVal(isolate(input$duration*60))
  active <- reactiveVal(FALSE)
  
  # Output the time left.
  output$countdown <- renderText({
    
    req(input$start)
    
    dur <- timer()
    
    mins <- floor(dur/60)
    secs <- dur %% 60
    sprintf("%2d:%02d",mins,secs)
    
  })
  
  # observer that invalidates every second. If timer is active, decrease by one.
  observe({
    invalidateLater(1000, session)
    isolate({
      if(active())
      {
        timer(timer() - 1)
        if(timer() < 1)
        {
          active(FALSE)
          shinyjs::enable("duration")
          showModal(modalDialog(
            title = "Coundown complete",
            "Time's up!"
          ))
        }
      }
    })
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

