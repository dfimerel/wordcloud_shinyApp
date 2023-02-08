#load packages and global script
library(wordcloud2)
library(tools)
source("global.R")

# available shapes for the wordcloud 
shapes=c("circle","diamond","triangle","pentagon","star")



# Define the ui code  
ui <- fluidPage(
  tabsetPanel(
    tabPanel(
      title = "Word cloud",
           sidebarLayout(
               sidebarPanel(
                   fileInput("file", 
                             NULL,
                             buttonLabel = "Choose File",
                             multiple = FALSE,
                             accept = c("text/plain")),
                   actionButton("run", "Use your data"),
                   actionButton("run_demo", "Use demo data instead"),
                   hr(),
                   radioButtons("radio", "Choose the background color:",choices=list("White"="white","Black"="black"),selected="white"),
                   selectInput("select", label = "choose the cloud shape", choices = shapes),
                   numericInput("numero",label="Choose the number of words to display",value=25,min=10,max=50,step=5)
               ),

               mainPanel(
                 h2("Create a random word clould from your text",align = "center"),  
                 wordcloud2Output("plot")  
               )
           )
      ),
    tabPanel(
      title = "About this app",
      br(),
      "Instructions on how to use this Shiny app:",
      br(),
      "You need to give as input a text file (.txt file extension) that contains the text from which you want to create your worldcloud.",
      br(),
      "Or you can also use a demo text from the poem of Maya Angelou 'Caged Bird'",
      br(),
      "You are free to choose the shape of the cloud and the number of words to display or leave them to defaults values."
    )
  )
)


# Define the server code
server <- function(input, output) {

  # Here is what happens when user data button is pushed
  observeEvent(input$run, {
    # Get the file data
    fileData <- input$file
    if (is.null(fileData)) return(NULL)
    req(fileData)
    tbl <- readTheInput(fileData$datapath)
    
    output$plot <- renderWordcloud2({
      freqLimit=head(tbl,input$numero)
      wordcloud2(freqLimit[,c("word","freq")],backgroundColor=input$radio,shape=input$select,size=0.5)
      
    })
  }) # end of the first observe
  
  
  # Here is what happens when demo data button is pushed
  observeEvent(input$run_demo, {
    
    # Get the file data
    demo_data = readTheInput("demoText.txt")
    
    output$plot <- renderWordcloud2({
      freqLimit=head(demo_data,input$numero)
      wordcloud2(freqLimit[,c("word","freq")],backgroundColor=input$radio,shape=input$select,size=0.5)
  })
    
  }) # end of the second observe
     
}



shinyApp(ui = ui, server = server)

