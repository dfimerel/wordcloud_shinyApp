#load packages and global script
library(wordcloud2)
library(tools)
source("global.R")

# available shapes for the wordcloud 
shapes=c("circle","diamond","triangle","pentagon","star")



# Define the ui code  
ui <- fluidPage(
titlePanel("Create Wordclouds of your text"),
 
           sidebarLayout(
              
               sidebarPanel(
                   fileInput("file1", "Choose your Text File to upload", multiple = FALSE,accept = c("text/plain")),
                   hr(),
	           radioButtons("radio", "Choose the background color:",choices=list("White"="white","Black"="black"),selected="white"),
                   selectInput("select", label = "choose the cloud shape", choices = shapes),
		   numericInput("numero",label="Choose the number of words to display",value=25,min=10,max=50,step=5),
		   hr(),
                   h4("This Shiny app creates a wordcloud from the most frequent words of your uploaded text. It was created with the R package wordcloud2."),
		   h4("For the moment, only .txt files are accepted. Some example files and the R code can be found here: https://github.com/dfimerel")
 
               
               ),

               mainPanel(
                   wordcloud2Output("plot")  
               )
           )
)


# Define the server code
server <- function(input, output) {

      observe ({
	    
	inFile <- input$file1

        if (is.null(inFile))
        return(NULL)

         

        df <- readTheInput(inFile$datapath)
     	

       output$plot <- renderWordcloud2({
	   freqLimit=head(df,input$numero)
          wordcloud2(freqLimit[,c("word","freq")],backgroundColor=input$radio,shape=input$select,size=0.5)
        
       })

    }) # end of observe
}


shinyApp(ui = ui, server = server)

