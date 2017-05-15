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
  dat <- dat[!is.na(dat$Assay), ]

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
              selected =  choice[1],  #state_multiple("name_Med", choice),
              multiple =TRUE, size = min(3, length(choice)), selectize = FALSE
  )

})




display_Medical_report <- function(){
  report_Path <- paste0( readDirectoryInput(session, 'directory'), input$periodeId_Med, sep="")

  #report_Path <- paste0("../extdata/reports/", input$periodeId_Med, sep="")

  personal_reports <- as.list(list.files(report_Path)[grep(paste0(input$name_Med,collapse = "|"), # collapse "|" usefull if multiple name_Med is selected
                                                           list.files(report_Path),
                                                           ignore.case = TRUE)
                                                      ])


  return(personal_reports)

}


output$ui_Medical_reports <- renderUI({


  choice <- display_Medical_report()

  selectInput(inputId = "reports_Med", label= "Report files:", choices = choice,
              selected =  choice[1],  #state_multiple("name_Med", choice),
              multiple =TRUE, size = min(3, length(choice)), selectize = FALSE)
})


## render multiple Image using lapply

lapply(1:6, function(i){
  output[[paste0('display_image',i)]] <- renderImage({

    #print(length(display_Medical_report()))

    ## without selecting report files
    #image_file <- paste(paste0(readDirectoryInput(session, 'directory'), input$periodeId_Med, sep=""),
     #                   "/", display_Medical_report()[i] ,sep="")

    ##  with selecting report file input$reports_Med from sidebar menu
    image_file <- paste(paste0(readDirectoryInput(session, 'directory'), input$periodeId_Med, sep=""),
                                           "/", input$reports_Med[i] ,sep="")


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

      wellPanel(
        ## set Path directory. default ~  or ../extdata/reports/
        directoryInput('directory', label = 'Selected medical report directory',
                       value = '../extdata/reports/'),

        h5(paste0("Check box to view medical report"), align="left", style = "color:red"),


          div(class="row",
              div(class="col-xs-4",
        tagList(
        checkboxInput("view_MedReportID", label="")
        )
        ),
        div(class="col-xs-5",
        tagList(
        icon = icon("arrow-left")
        )
        )
        )

        #actionButton("view_MedReportID", "Check box to view medical report",   icon=icon("arrow-right"))
      ),

      uiOutput("ui_periode_Medical"),
      uiOutput("ui_split_Medical"),
      uiOutput("ui_name_Medical"),
      uiOutput("ui_Medical_reports"),

      ## browse image
      fileInput(inputId = 'files',
                #value = '../extadata/reports/',
                label = 'Select an Image to zoom in',
                multiple = TRUE,
                accept=c('image/png', 'image/jpeg')),

      sliderInput("zoom_MedicalReport",
                  "Scale in pixel:",
                  min = 360,
                  max = 1080,
                  value = 360),

      help_and_report(modal_title = "Medical Reports", fun_name = "medical",
                      author = "Karim Mezhoud",
                      help_file = inclRmd(file.path(
                        getOption("radiant.path.dose"),"app/tools/help/medical.Rmd")))


    ),
    #####  Main Page ###
    mainPanel(
      tabsetPanel(
   tabPanel("Image",
      tagList(

      # tags$h5('Files path'),
       # dataTableOutput('filesPath'),
       # textOutput('directory'),

        conditionalPanel("input.view_MedReportID==true",
                         lapply(1:6, function(i){

                           div(style="display:inline-block",
                               tags$a(imageOutput(paste0("display_image",i),
                                                  width= 330), # input$zoom_MedicalReport
                                      href="https://www.google.com" )
                               #helpText( a("Click Here for the Source Code on Github!",
                               #           href="https://github.com/Bohdan-Khomtchouk/Microscope",target="_blank"))
                           )
                         })
        )
        ,

        #### begin display image from file
        #tableOutput('files'),
        uiOutput('images')
        #### end display image from file


      )
   ),
   tabPanel("Numeric")
      )
    )
  )

})
