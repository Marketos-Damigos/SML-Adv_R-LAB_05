#' elections RC Class
#'
#'@description This class downloads Swedish elections results.
#'
#'@field parliament. Data frame. 
#'@field council. Data frame.
#'@field muni. Data frame.
#'@import methods
#'@import shiny
#'@import readxl
#'@return Nothing.
#'@export elections
#'@exportClass elections




elections <- setRefClass("elections",
                         fields = list(
                           parliament = "data.frame",
                           council = "data.frame",
                           muni = "data.frame"),
                         
                         methods = list(
                           
                           initialize = function(el_y, ...){
                             if(el_y %in% c("2010", "2014", "2018")){
                               if (el_y == "2010"){
                                 
                                 url_parl = "https://data.val.se/val/val2010/statistik/slutligt_valresultat_kommuner_R.xls"
                                 url_council = "https://data.val.se/val/val2010/statistik/slutligt_valresultat_kommuner_L.xls"
                                 url_muni = "https://data.val.se/val/val2010/statistik/slutligt_valresultat_kommuner_K_procent.xls"
                                 
                                 dir.create("./temp_data")
                                 
                                 destfile <- "./temp_data/parliament.xls"
                                 download.file(url_parl, destfile)
                                 parliament <<- readxl::read_xls(destfile)
                                 
                                 destfile <- "./temp_data/council.xls"
                                 download.file(url_council, destfile)
                                 council <<- readxl::read_xls(destfile)
                                 
                                 destfile <- "./temp_data/muni.xls"
                                 download.file(url_muni, destfile)
                                 muni <<- readxl::read_xls(destfile)
                                 
                                 unlink("./temp_data", recursive = TRUE)
                                 
                               }else if (el_y == "2014"){
                                 url_parl = "https://data.val.se/val/val2014/statistik/2014_riksdagsval_per_kommun.xls"
                                 url_council = "https://data.val.se/val/val2014/statistik/2014_landstingsval_per_kommun.xls"
                                 url_muni = "https://data.val.se/val/val2014/statistik/2014_kommunval_per_kommun.xlsx"
                                 
                                 dir.create("./temp_data")
                                 
                                 destfile <- "./temp_data/parliament.xls"
                                 download.file(url_parl, destfile, method="libcurl", mode = "wb")
                                 parliament <<- readxl::read_xls(destfile, skip = 2)
                                 
                                 destfile <- "./temp_data/council.xls"
                                 download.file(url_council, destfile, method="libcurl", mode = "wb")
                                 council <<- readxl::read_xls(destfile, skip = 2)
                                 
                                 destfile <- "./temp_data/muni.xlsx"
                                 download.file(url_muni, destfile, method="libcurl", mode = "wb")
                                 muni <<- readxl::read_xlsx(destfile, skip = 2)
                                 
                                 unlink("./temp_data", recursive = TRUE)
                                 
                               }else{
                                 url_parl = "https://data.val.se/val/val2018/statistik/2018_R_per_kommun.xlsx"
                                 url_council = "https://data.val.se/val/val2018/statistik/2018_L_per_kommun.xlsx"
                                 url_muni = "https://data.val.se/val/val2018/statistik/2018_K_per_kommun.xlsx"
                                 
                                 dir.create("./temp_data")
                                 
                                 destfile <- "./temp_data/parliament.xlsx"
                                 download.file(url_parl, destfile)
                                 parliament <<- readxl::read_xlsx(destfile, sheet = "R antal")
                                 
                                 destfile <- "./temp_data/council.xlsx"
                                 download.file(url_council, destfile)
                                 council <<- readxl::read_xlsx(destfile, sheet = "L antal")
                                 
                                 destfile <- "./temp_data/muni.xlsx"
                                 download.file(url_muni, destfile)
                                 muni <<- readxl::read_xlsx(destfile, sheet = "K antal")
                                 
                                 unlink("./temp_data", recursive = TRUE)
                               }
                            
                             }else{
                               stop("Wrong year. Select between 2010, 2014, 2018.")
                             }
                             
                           },
                           shiny = function(){
                             
                             
                             ui <- fluidPage(
                               title = "Swedish Elections",
                               sidebarLayout(
                                 sidebarPanel(
                                   conditionalPanel(
                                     'input.dataset == "Parliament"',
                                     checkboxGroupInput("parl_vars", "Columns in Parliament elections:",
                                                        names(parliament), selected = colnames(parliament[4:10]))
                                   ),
                                   conditionalPanel(
                                     'input.dataset == "Council"',
                                     checkboxGroupInput("council_vars", "Columns in Council elections:",
                                                        names(council), selected = colnames(council[4:10]))
                                   ),
                                   conditionalPanel(
                                     'input.dataset == "Municipal"',
                                     checkboxGroupInput("mouni_vars", "Columns in Municipal elections:",
                                                        names(muni), selected = colnames(muni[4:10]))
                                   )
                                 ),
                                 mainPanel(
                                   tabsetPanel(
                                     id = 'dataset',
                                     tabPanel("Parliament", DT::dataTableOutput("mytable1")),
                                     tabPanel("Council", DT::dataTableOutput("mytable2")),
                                     tabPanel("Municipal", DT::dataTableOutput("mytable3"))
                                   )
                                 )
                               )
                             )
                             
                             server <- function(input, output) {
                               
                               # choose columns to display
                               output$mytable1 <- DT::renderDataTable({
                                 DT::datatable(parliament[, input$parl_vars, drop = FALSE],filter = 'top', options = list(pageLength = 50, autoWidth = TRUE, orderClasses = TRUE))
                               })
                               
                               # sorted columns are colored now because CSS are attached to them
                               output$mytable2 <- DT::renderDataTable({
                                 DT::datatable(council[, input$council_vars, drop = FALSE], filter = 'top', options = list(pageLength = 50, autoWidth = TRUE, orderClasses = TRUE))
                               })
                               
                               # customize the length drop-down menu; display 5 rows per page by default
                               output$mytable3 <- DT::renderDataTable({
                                 DT::datatable(muni[, input$mouni_vars, drop = FALSE], filter = 'top', options = list(pageLength = 50, autoWidth = TRUE, orderClasses = TRUE))
                               })
                               
                             }
                             
                             shinyApp(ui, server)
                             
                              
                            
                           }
                           
                         
                         )
)