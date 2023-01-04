library(shiny)
library(mailR)
library(DBI)
library(dplyr)
library(RMariaDB)

source("setup.R")

ui <- fluidPage(

  tags$head(
    # Include the Nord Light CSS styles
    tags$style(HTML("
      /* Nord Light color palette */
      :root {
        --nord00: #D8DEE9;
        --nord01: #f5f7fa;
        --nord02: #d8dee9;
        --nord03: #e5e9f0;
        --nord04: #4C566A;
        --nord05: #8fbcbb;
        --nord06: #88c0d0;
        --nord07: #81a1c1;
        --nord08: #5e81ac;
        --nord09: #bf616a;
        --nord0a: #d08770;
        --nord0b: #ebcb8b;
        --nord0c: #a3be8c;
        --nord0d: #b48ead;
        --nord0e: #2e3440;
        --nord0f: #3b4252;
      }

      /* Nord Light style */
      body {
        background-color: var(--nord00);
        color: var(--nord04);
        font-family: 'Fira Sans', sans-serif;
      }

      a {
        color: var(--nord0d);
      }

      a:hover {
        color: var(--nord0b);
      }

      input[type='text'],
      input[type='email'],
      textarea {
        background-color: var(--nord01);
        border: none;
        color: var(--nord04);
        font-family: 'Fira Sans', sans-serif;
        font-size: 16px;
        padding: 8px;
      }

      input[type='submit'] {
        background-color: var(--nord0
      "))
  ),
  div(style = "display: flex; justify-content: center; align-items: center; height: 100vh;",
      column(width = 6,
             textInput("name", "Name"),
             textInput("email", "Email"),
             textAreaInput("message", "Message", rows = 5),
             actionButton("submit", "Submit")
)))


server <- function(input, output, session) {

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

  newSubmission <- data.frame(
    mail = input$email,
    date = paste(Sys.Date()),
    time = paste(Sys.time()),
    name = input$name,
    message = input$message
  )

  apnd <- sqlAppendTable(my_db, "submissions", newSubmission)

  dbExecute(my_db, apnd)

  session$reload

  }) # observeEvent
}

shinyApp(ui = ui, server = server)
