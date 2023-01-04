library(shiny)
library(mailR)

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
  }) # observeEvent
}

shinyApp(ui = ui, server = server)
