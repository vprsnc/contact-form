library(shiny)

shinyUI(fluidPage(

  # Form for user input
  fluidRow(
    column(6,
           textInput("name", "Name", ""),
           textInput("email", "Email", ""),
           textAreaInput("message", "Message", "")
    ),
    column(6,
           actionButton("send", "Send")
    )
  ),
  verbatimTextOutput("output")
))

# In the server.R file

library(shiny)

shinyServer(function(input, output) {

  # Send email when the send button is clicked
  observeEvent(input$send, {
    sendEmail(from = input$email,
              to = "you@example.com",
              subject = paste("Contact form submission from", input$name),
              body = input$message)
    output$output <- renderText("Thank you for your message!")
  })

})
