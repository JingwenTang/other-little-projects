# 08-reactiveValues
library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
con <- dbConnect(MySQL(),username='root',password='Tjw',port=3306,dbname='bus')
querryData <- dbGetQuery(con,'SELECT * FROM line')
ui <- fluidPage(
    actionButton(inputId = "subline_stat", label = "subline_stat"),
  plotOutput("bar")
  
)
server <- function(input, output,session) {

  rv <- reactiveValues(data = rnorm(100),subline = "null") 
  observeEvent(input$subline_stat, { rv$data <- as.numeric(dbGetQuery(con,"SELECT subline.subline_ID,COUNT(passenger.seat_ID) AS customer_number 
                                                            FROM passenger JOIN seat ON passenger.seat_ID = seat.seat_ID
                                                           JOIN bus ON seat.bus_ID = bus.bus_ID
                                                           JOIN subline ON bus.subline_ID = subline.subline_ID
                                                           GROUP BY subline_ID")$customer_number) })
  observeEvent(input$subline_stat, { rv$subline <- (dbGetQuery(con,"SELECT subline.subline_ID,COUNT(passenger.seat_ID) AS customer_number 
                                                            FROM passenger JOIN seat ON passenger.seat_ID = seat.seat_ID
                                                                      JOIN bus ON seat.bus_ID = bus.bus_ID
                                                                      JOIN subline ON bus.subline_ID = subline.subline_ID
                                                                      GROUP BY subline_ID")$subline_ID) })
    output$bar <- renderPlot({
    barplot(rv$data, names.arg = as.vector(unlist(rv$subline)))
  }) 
  
}
shinyApp(ui = ui, server = server)
#dbListConnections( dbDriver( drv = "MySQL"))
#lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)
#dbSendQuery(con,'INSERT INTO passenger VALUES (2, 02010101,"wendy123", "wendy")')
