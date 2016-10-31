## date Range exposure
output$ui_periode_dosimetry <- renderUI({

  ls_periode <- unique(r_data[[input$dataset]][['Date']])

  periode <- sapply(ls_periode, function(x) as.character(x)) #as.POSIXlt.date(x,tz= Sys.timezone())

  selectInput(inputId = "periode", label = "Date Range:", choices = sort(periode),
              selected =  state_multiple("periode", periode),
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
              #selected = state_multiple("data_yvar", vars),multiple = FALSE, size = length(vars),
               selectize = FALSE)
})

## X - variable
output$ui_data_xvar <- renderUI({

  #req('scatter')
  vars <- varying_vars()

  selectInput(inputId = "data_xvar", label = "X-variable:", choices = vars,
              selected = state_multiple("data_xvar", vars),
              #multiple = FALSE, size = min(3, length(vars)),
              selectize = FALSE
              )
})


output$ui_fill <- renderUI({

  vars <- c(`None` = 'None', varying_vars())
  ## omit numeric vars
  vars <- vars["numeric" != .getclass()[vars]]

  selectInput(inputId = "data_fill", label = "Fill variable by:", choices = vars,
              selected = state_multiple("data_fill", vars),
              #multiple = FALSE, size = min(3, length(vars)),
              selectize = FALSE)
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
      # dateRangeInput('dateRange',
      #                label = 'Date range input: yyyy-mm-dd',
      #                start = min(unique(r_data[[input$dataset]][['Date']])) ,
      #                end = max(unique(r_data[[input$dataset]][['Date']]))
      # ),
      tags$table(
        tags$td(numericInput("plot_height", label = "Plot height:", min = 100,
                             max = 2000, step = 50,
                             value = state_init("plot_height", 400),
                             width = "117px")),

        tags$td(numericInput("plot_width", label = "Plot width:", min = 100,
                             max = 2000, step = 50,
                             value = state_init("plot_width",1000),
                             width = "117px"))
      ),
      help_and_report(modal_title = "dosimetry", fun_name = "dosimetry",
                      author = "Karim Mezhoud",
                      help_file = inclRmd(file.path(
                        getOption("radiant.path.dose"),"app/tools/help/dosimetry.Rmd")))



    ),


    #####  Main Page ###
    mainPanel(
      tagList(
        #column(width = 12, class = "well",
        # column(width = 6,
        #        h4("DCE"),
        # plotOutput("plot_dosimetry1", height = 300,
        #            # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
        #            click = "plot_dosimetry_click",
        #            brush = brushOpts(
        #              id = "plot_dosimetry_brush"
        #            )
        # )
        # ),
        #
        # column(width = 6,
        #        h4("DP"),
        #        plotOutput("plot_dosimetry2", height = 300,
        #                   # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
        #                   click = "plot_dosimetry_click",
        #                   brush = brushOpts(
        #                     id = "plot_dosimetry_brush"
        #                   )
        #        )
        # ),
        column(width = 12,
               #h4(paste0(input$data_yvar, " vs ", input$data_xvar),  align = "center"),
               plot_downloader("ld_barplot_dosimetry", width= plot_width(), height=plot_height(), pre = ""),
               plotOutput("barplot_dosimetry", height = input$plot_height, width = input$plot_width)
        ),

        column(width = 6,

               h4(' Scatter plot', align= 'center'),
               plot_downloader("ld_scatterplot_dosimetry", width= plot_width(), height=plot_height(), pre = ""),
        plotOutput("scatterplot_dosimetry", height = input$plot_height, width = input$plot_width,
                   # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
                   click = "plot_dosimetry_click",
                   brush = brushOpts(
                     id = "plot_dosimetry_brush"
                   )
        )
        ),
        # column(width = 6,
        #        h4(' Sum DCE'),
        #        plotOutput("plot_dosimetrySum", height = 300,
        #                   # Equivalent to: click = clickOpts(id = "plot_dosimetry_click")
        #                   click = "plot_dosimetry_click",
        #                   brush = brushOpts(
        #                     id = "plot_dosimetry_brush"
        #                   )
        #        )
        # ),
        # column(width = 6,
        #        h4(' all DCE')
        #        #plotOutput("plot_dosimetryBis", height = 300)
        # ),
        #
        # column(width = 6,
        #        h4(' Department VS Date')
        #        #plotOutput("plot_Department_Date", height = 300)
        #        ),
        #
        # column(width = 6,
        #        h4(' Department VS Name')
        #        #plotOutput("plot_Department_Name", height = 300)
        # ),
        column(width = 12,
        div(
        DT::dataTableOutput("plot_brushed_points"),
        style = "font-size:60%"
        )
        )

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





#
# output$ui_dosimetry <- renderUI({
#   tagList(
#
#     wellPanel(
#     )
#
#   )
# })

