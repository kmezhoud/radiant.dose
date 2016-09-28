# output$ui_datasets_edit <- renderUI({
#   tagList(
#     selectInput(inputId = "datasetsEdit", label = "Datasets:", choices = r_data$datasetlist,
#                 selected = state_init("dataset"), multiple = FALSE)
#   )
# })

# output$ui_data_vars <- renderUI({
#
#  dat <- r_data[[input$dataset]]
#  vars <- names(dat)
#
#   selectInput("data_vars", "Select variables to show:", choices  = vars,
#               selected = state_multiple("data_vars", vars, vars) , multiple = TRUE,
#               selectize = FALSE, size = min(15, length(vars)))
#
#   })

#############################################
# View table output of the selected dataset
#############################################
output$ui_edata_vars <- renderUI({
  vars <- varnames()
  if (not_available(vars)) return()
  isolate({
    if (not_available(r_state$edata_vars)) {
      r_state$edata_vars <<- NULL
      r_state$edataviewer_state <<- list()
      r_state$edataviewer_search_columns <<- NULL
    }
  })

  selectInput("edata_vars", "Select variables to show:", choices  = vars,
              selected = state_multiple("edata_vars", vars, vars), multiple = TRUE,
              selectize = FALSE, size = min(15, length(vars)))
})


output$ui_evars <- renderUI({
  tagList(

  lapply(1:length(input$edata_vars), function(i) {
    div(
     textInput(paste0(input$edata_vars[i],i), label = input$edata_vars[i], "")
    )
  }),
  actionButton("submit_evars", "Submit"),
  actionButton("reset_evars", "Reset")
  #actionButton("delete_evars", "Delete")
  )
})

output$ui_eData <- renderUI({
  tagList(
    shinyjs::useShinyjs(),
    wellPanel(
    #checkboxInput("data_pause", "Pause view", state_init("data_pause", FALSE)),
    uiOutput("ui_edata_vars"),
    uiOutput("ui_evars")
),
help_and_report(modal_title = "Edit Data", fun_name = "eData",
                help_file = inclRmd(file.path(getOption("radiant.path.dose"),"app/tools/help/eData.Rmd")))

#help_modal('EditData','editData_Help',inclMD(file.path(getOption("radiant.path.dose"),"app/tools/help/eData.md")))
  )
})

output$dataEdit <- DT::renderDataTable({


  dat <- r_data[[input$dataset]][input$edata_vars]
  #dat <- select_(.getdata(), .dots = input$data_vars)

  ## update state when view_vars changes
  # if (!identical(r_state$data_vars, input$data_vars)) {
  #   r_state$data_vars <<- input$data_vars
  #   r_state$data_state <<- list()
  #   #r_state$dataviewer_search_columns <<- rep("", ncol(dat))
  # }
   displayTable(dat, session=session)
  # search <- r_state$data_state$search$search
  # if (is.null(search)) search <- ""
  # fbox <- if (nrow(dat) > 5e6) "none" else list(position = "top")
  #
  # withProgress(message = 'Generating view table', value = 1,
  #              DT::datatable(dat, filter = fbox, selection = "none",
  #                            rownames = FALSE, style = "bootstrap", escape = FALSE,
  #                            options = list(
  #                              stateSave = TRUE,   ## maintains state
  #                              searchCols = lapply(r_state$dataviewer_search_columns, function(x) list(search = x)),
  #                              search = list(search = search, regex = TRUE),
  #                              order = {if (is.null(r_state$data_state$order)) list()
  #                                else r_state$data_state$order},
  #                              columnDefs = list(list(orderSequence = c("desc", "asc"), targets = "_all"),
  #                                                list(className = "dt-center", targets = "_all")),
  #                              autoWidth = TRUE,
  #                              processing = FALSE,
  #                              pageLength = {if (is.null(r_state$data_state$length)) 10 else r_state$data_state$length},
  #                              lengthMenu = list(c(5, 10, 25, 50, -1), c("5", "10","25","50","All"))
  #                            ),
  #                            callback = DT::JS("$(window).unload(function() { table.state.clear(); })")
  #              )
  # )
})
