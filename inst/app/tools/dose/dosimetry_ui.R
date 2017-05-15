## date Range exposure
output$ui_periode_dosimetry <- renderUI({

  dat <- r_data[[input$dataset]]
## remove rows and dates with medical data
  dat <-dat[is.na(dat$Essay), ]


  ##check for Date column
  date_Column <- names(which(sapply(dat, is.Date) ==TRUE))

  ls_periode <- unique(dat[[date_Column]])

  periode <- sapply(ls_periode, function(x) as.character(x)) #as.POSIXlt.date(x,tz= Sys.timezone())

  selectInput(inputId = "periodeId", label = "Date Range:", choices = sort(periode),
              selected =  state_multiple("periodeId", periode),
              multiple =TRUE, size = min(3, length(periode)), selectize = FALSE)

})

## Split dataset by
output$ui_split_dosimetry <- renderUI({

  choice <- list(`None` = 'All' ,
                 `Department` = unique(as.character(r_data[[input$dataset]]$Department))
                 #`Categories` = unique(as.character(r_data[[input$dataset]]$Categories))
  )

  selectInput(inputId = "split_dosimetry", label = "Split data set by:",
              choices = choice,
              selectize = FALSE)
})

## Y - variable
output$ui_data_yvar <- renderUI({

  req('scatter')
  vars <- varying_vars()
  ## avoid factor and Date un y-axis
  vars <- vars["date" != .getclass()[vars]]
  if ('scatter' %in% c("line","bar","scatter","surface", "box")) {
    vars <- vars["character" != .getclass()[vars]]
  }
  if ('scatter' %in% c("line","scatter","box")) {
    ## allow factors in yvars for bar plots
    vars <- vars["factor" != .getclass()[vars]]
  }

  selectInput(inputId = "data_yvar", label = "Y-variable:",
              choices = vars,
              selected = state_multiple("data_yvar", input$data_yvar),
              #multiple = FALSE, size = length(vars),
              selectize = FALSE)
})

## X - variable
output$ui_data_xvar <- renderUI({

  #req('scatter')
  vars <- varying_vars()

  selectInput(inputId = "data_xvar", label = "X-variable:", choices = vars,
              selected = state_multiple("data_xvar", input$data_xvar),
              #multiple = FALSE, size = min(3, length(vars)),
              selectize = FALSE
  )
})

output$ui_fill <- renderUI({

  vars <- c(`None` = 'None', varying_vars())
  ## omit numeric vars
  vars <- vars["numeric" != .getclass()[vars]]

  selectInput(inputId = "data_fill", label = "Fill variable by:", choices = vars,
              selected = state_multiple("data_fill", input$data_fill),
              #multiple = FALSE, size = min(3, length(vars)),
              selectize = FALSE)
})

output$ui_typePlot <- renderUI({
  type <- c('Bar', 'Scatter')
  selectInput(inputId = "dosimetry_typePlot", label = "Type Plot:", choices = type,
              selected = state_multiple("dosimetry_typePlot", input$dosimetry_typePlot),
              multiple = FALSE,
              #size = min(3, length(vars)),
              selectize = FALSE
  )
})


output$dosimetry <- renderUI({

  sidebarLayout(

    #####  Sidebar Panels ###
    sidebarPanel(
      uiOutput("ui_periode_dosimetry"),
      uiOutput("ui_split_dosimetry"),
      uiOutput("ui_data_yvar"),
      uiOutput("ui_data_xvar"),
      uiOutput("ui_fill"),
      uiOutput("ui_typePlot"),
      # dateRangeInput('dateRange',
      #                label = 'Date range input: yyyy-mm-dd',
      #                start = min(unique(r_data[[input$dataset]][['Date']])) ,
      #                end = max(unique(r_data[[input$dataset]][['Date']]))
      # ),
      # tags$table(
      #   tags$td(numericInput("plot_height_dosimetry", label = "Plot height:", min = 400,
      #                        max = 400, step = 50,
      #                        value = state_init("plot_height_dosimetry", 400),
      #                        width = "117px")),
      #
      #   tags$td(numericInput("plot_width_dosimetry", label = "Plot width:", min = 1000,
      #                        max = 1000, step = 50,
      #                        value = state_init("plot_width_dosimetry",1000),
      #                        width = "117px"))
      # ),

      help_and_report(modal_title = "Dosimetry", fun_name = "dosimetry",
                      author = "Karim Mezhoud",
                      help_file = inclRmd(file.path(
                        getOption("radiant.path.dose"),"app/tools/help/dosimetry.Rmd")))



    ),


    #####  Main Page ###
    mainPanel(
      tagList(

        conditionalPanel("input.dosimetry_typePlot == 'Bar'",
        column(width = 12,
               #h4(paste0(input$data_yvar, " vs ", input$data_xvar),  align = "center"),
               plot_downloader("ld_barplot_dosimetry", width= plot_width_dosimetry(), height=plot_height_dosimetry(), pre = ""),
               plotOutput("barplot_dosimetry", height = 400, width = 1000),
               h4(paste0('List of persons with excessive cumulative doses(> threshold (mSv) / range date)'), align='center'),
               DT::dataTableOutput("Upper_threshold")
        )
        ),
        conditionalPanel(" input.dosimetry_typePlot == 'Scatter'",
        column(width = 6,

               #h4(' Scatter plot', align= 'center'),
               plot_downloader("ld_scatterplot_dosimetry", width= plot_width_dosimetry(), height=plot_height_dosimetry(), pre = ""),
               plotOutput("scatterplot_dosimetry", height = 400, width = 1000,
                          # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
                          click = "plot_dosimetry_click",
                          brush = brushOpts(
                            id = "plot_dosimetry_brush"
                          )
               )
        ),

        column(width = 12,
               div(
                 DT::dataTableOutput("plot_brushed_points"),
                 style = "font-size:80%"
               )
        )
        )
        # column(width = 6,
        #        h4(' Sum DCE'),
        #        plotOutput("plot_dosimetrySum", height = 400, width = 1000,
        #                   # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
        #                   click = "plot_dosimetry_click",
        #                   brush = brushOpts(
        #                     id = "plot_dosimetry_brush"
        #                   )
        #        )
        # )

        # column(width = 6,
        #        h4("Points near click")
        #        #verbatimTextOutput("click_info")
        # ),
        # column(width = 6,
        #        h4("Brushed points")
        #        #verbatimTextOutput("brush_info")
        # )

      )
    )
  )
})

