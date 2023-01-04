library(shiny)
library(mailR)
library(RMariaDB)

source("setup.R")

ui <- fluidPage(
  textInput("name", "Name", ""),
  textInput("email", "Email", ""),
  textAreaInput("message", "Message", ""),
  actionButton("submit", "Submit")
)

server <- function(input, output) {

  # Send email when submit button is clicked
  observeEvent(input$submit, {
    send.mail(from = input$email,
          to = "georgy@analytics-abc.xyz",
          subject = paste("Form submission from ", input$name),
          body = paste0("Name: ", input$name, "\n",
                        "Email: ", input$email, "\n",
                        "Message: ", input$message),
          smtp = my.controls,
          authenticate = TRUE,
          send = TRUE)


  my_db <- dbConnect(MariaDB(),
                     dbname = dbname,
                     host = dbhostname,
                     port = dbport,
                     user = dbuser,
                     password = dbpass)

  newSubmission <- list(
    from = input$email,
    date = paste(Sys.Date()),
    time = paste(Sys.time()),
    name = input$name,
    subject = input$subject,
    message = input$message
  )%>% data.frame()

  dbAppendTable(my_db, "submissions", newSubmission)

  }) # observeEvent
}

shinyApp(ui = ui, server = server)
