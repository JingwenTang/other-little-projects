# 08-reactiveValues
library(shiny)
library(DBI)
library(RMySQL)
con <- dbConnect(MySQL(),username='root',password='Tjw',port=3306,dbname='bus')
querryData <- dbGetQuery(con,'SELECT * FROM line')[,c("line_Name","line_type")]
ui <- fluidPage(
  selectInput(inputId = "select_line", label = "line", choices = dbGetQuery(con,'SELECT line_Name FROM line')$line_Name),
  selectInput(inputId = "select_subline", label = "subline", choices = NULL),
  selectInput(inputId = "select_bus", label = "bus", choices = NULL),
  selectInput(inputId = "select_seat", label = "seat", choices = NULL),
  actionButton(inputId = "query", label = "query"),
  textOutput(outputId = "passenger_ID_text"),
  textOutput(outputId = "passenger_ID")
)
server <- function(input, output,session) {
  observeEvent(input$select_line,{
    updateSelectInput(session,'select_subline',
                      choices = dbGetQuery(con,paste("SELECT subline_start FROM subline WHERE line_ID = (SELECT DISTINCT line_ID FROM line WHERE line_Name = '",input$select_line,"')",sep = ""))$subline_start)
  }) 
  observeEvent(input$select_subline,{
    updateSelectInput(session,'select_bus',
                      choices = dbGetQuery(con,paste("SELECT bus_ID FROM bus WHERE subline_ID = (SELECT DISTINCT subline_ID FROM subline WHERE subline_start = '",input$select_subline,"')",sep = ""))$bus_ID)
  }) 
  observeEvent(input$select_bus,{
    updateSelectInput(session,'select_seat',
                      choices = dbGetQuery(con,paste("SELECT seat_ID FROM seat WHERE bus_ID = ('",input$select_bus,"')",sep = ""))$seat_ID)
  }) 
  a <- reactiveValues(temp = "The seat belongs to: ")
  output$passenger_ID_text <- eventReactive(input$query,{a$temp})
  output$passenger_ID <- eventReactive(input$query,  {as.character(dbGetQuery(con,paste("SELECT passenger_ID,passenger_name FROM passenger WHERE seat_ID = '",input$select_seat,"'",sep = "") )[1,c("passenger_ID","passenger_name")]) })
}
shinyApp(ui = ui, server = server)
#dbListConnections( dbDriver( drv = "MySQL"))
#lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)
#dbSendQuery(con,'INSERT INTO passenger VALUES (2, 02010101,"wendy123", "wendy")')
