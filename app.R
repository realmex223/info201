library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Multipage App with Tabs"),
  tabsetPanel(
    tabPanel("intro", 
             fluidRow(
               box("Content for Page 1")
             )
    ),
    tabPanel("story one", 
             fluidRow(
               box("Content for Page 2")
             )
    ),
    tabPanel("Page 2", 
             fluidRow(
               box("Content for Page 2")
             )
    ),
    tabPanel("Page 3", 
             fluidRow(
               box("Content for Page 2")
             )
             ),
    tabPanel("conclusions", 
             fluidRow(
               box("Content for Page 2")
             )
    )
  )
)

# Define server
server <- function(input, output, session) {
  # Server logic goes here
}

# Run the application
shinyApp(ui, server)