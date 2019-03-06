# 08-reactiveValues
library(shiny)
library(DBI)
library(RMySQL)
con <- dbConnect(MySQL(),username='root',password='Tjw',port=3306,dbname='bus')
querryData <- dbGetQuery(con,'SELECT * FROM line')
ui <- fluidPage(
  textInput(inputId = "passenger_ID", label = "ID"),
  textInput(inputId = "passenger_name", label = "name"),
  passwordInput(inputId = "passenger_password", label = "password"),
  selectInput(inputId = "select_line", label = "line", choices = dbGetQuery(con,'SELECT line_Name FROM line')$line_Name),
  selectInput(inputId = "select_subline", label = "subline", choices = NULL),
  selectInput(inputId = "select_bus", label = "bus", choices = NULL),
  selectInput(inputId = "select_seat", label = "seat", choices = NULL),
  actionButton(inputId = "buy", label = "buy")
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
                      choices = dbGetQuery(con,paste("SELECT seat_ID FROM seat WHERE bus_ID = '",input$select_bus,"' AND seat_ID NOT IN (SELECT seat_ID FROM passenger)",sep = ""))$seat_ID)
  }) 
  
  observeEvent(input$buy,  {dbSendQuery(con,paste("INSERT INTO passenger VALUES ('",input$passenger_ID,"','", input$select_seat,"','", input$passenger_password,"','",input$passenger_name,"')",sep = ""))  })

  }
shinyApp(ui = ui, server = server)
#dbListConnections( dbDriver( drv = "MySQL"))
#lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)
#dbSendQuery(con,'INSERT INTO passenger VALUES (2, 02010101,"wendy123", "wendy)')
