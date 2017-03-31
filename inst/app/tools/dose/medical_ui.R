# output$ui_dataset_Medical <- renderUI({
#
#
# selectInput(inputId = "dataset_Med", label = "Datasets:",
#                     choices = r_data$datasetlist,
#                     selected = r_data$datasetlist[2])
#
# })


output$ui_which_dataset_med <- renderUI({
  h4(paste0("Dataset: ", input$dataset), align="left", style = "color:blue")
})


## date Range exposure
output$ui_periode_Medical <- renderUI({

  #dat <- r_data[['Medical_CNSTN']]
  dat <- r_data[[input$dataset]]

  ## remove rows and dates with medical data
  dat <- dat[!is.na(dat$Essay), ]

  ##check for Date column
  date_Column <- names(which(sapply(dat, is.Date) ==TRUE))

  ls_periode <- unique(dat[[date_Column]])

  periode <- sapply(ls_periode, function(x) as.character(x)) #as.POSIXlt.date(x,tz= Sys.timezone())

  selectInput(inputId = "periodeId_Med", label = "Date Range:", choices = sort(periode),
              selected =  state_multiple("periodeId_Med", periode),
              multiple =FALSE, size = min(3, length(periode)), selectize = FALSE)

})

## Split dataset by
output$ui_split_Medical <- renderUI({

  choice <- list(`None` = 'All' ,
                 `Department` = unique(as.character(r_data[[input$dataset]]$Department))
                 #`Categories` = unique(as.character(r_data[[input$dataset]]$Categories))
  )

  selectInput(inputId = "split_Medical", label = "Split data set by:",
              selected = 'None',
              choices = choice,
              selectize = FALSE)
})



output$ui_name_Medical <- renderUI({

  dat <- r_data[[input$dataset]]


  if(is.null(input$split_Medical) || input$split_Medical == 'All'){

   }else{
   dat <- dat[which(dat$Department == input$split_Medical),]
   }
  ## collapse Name and first name
  dat$x <- apply( dat[ , c('first.Name', 'Name') ] , 1 , paste , collapse = " " )

  choice <- unique(dat$x)

  selectInput(inputId = "name_Med", label= "Names:", choices = choice,
              selected =  state_multiple("name_Med", choice),
              multiple =FALSE, size = min(3, length(choice)), selectize = FALSE
              )

})




display_Medical_report <- function(){
  report_Path <- paste0("../extdata/reports/", input$periodeId_Med, sep="")

  personal_reports <- as.list(list.files(report_Path)[grep(input$name_Med, list.files(report_Path))])

 return(personal_reports)

}



lapply(1:3, function(i){
output[[paste0('display_image',i)]] <- renderImage({

  #print(display_Medical_report()[i])

  image_file <- paste(paste0("../extdata/reports/", input$periodeId_Med, sep=""),
                      "/", display_Medical_report()[i] ,sep="")

  return(list(
    src = image_file,
    filetype = "image/jpg",
    height = "1000%",
    width = "100%"
  ))

}, deleteFile = FALSE)

})


output$medical <- renderUI({

  sidebarLayout(

####  Sidebar Panels ###
    sidebarPanel(
      #uiOutput("ui_dataset_Medical"),
      uiOutput("ui_which_dataset_med"),
      uiOutput("ui_periode_Medical"),
      uiOutput("ui_split_Medical"),
      uiOutput("ui_name_Medical"),
     checkboxInput("ld", "Load"),

      ## browse image
      fileInput(inputId = 'files',
                label = 'Select an Image',
                multiple = TRUE,
                accept=c('image/png', 'image/jpeg'))


    ),
  #####  Main Page ###
  mainPanel(
    tagList(
conditionalPanel("input.ld==true",
  lapply(1:3, function(i){

    div(style="display:inline-block",
        tags$a(imageOutput(paste0("display_image",i), width=360), href="https://www.google.com" ),
        helpText( a("Click Here for the Source Code on Github!",
                      href="https://github.com/Bohdan-Khomtchouk/Microscope",target="_blank"))
        )
  })
)
 ,

  #### begin display image from file
  tableOutput('files'),
  uiOutput('images')
  #### end display image from file

  # lapply(1:length(input$edata_vars), function(i) {
  #   div(style="display:inline-block",
  #       textInput(paste0(input$edata_vars[i],i), label = input$edata_vars[i], "", width= "60%")
  #   )
  # })

#)

    )
  )
  )

})
