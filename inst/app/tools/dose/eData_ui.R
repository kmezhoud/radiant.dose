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


# output$ui_evars <- renderUI({
#   tagList(
#
#   lapply(1:length(input$edata_vars), function(i) {
#     div(
#      textInput(paste0(input$edata_vars[i],i), label = input$edata_vars[i], "")
#     )
#   }),
#   actionButton("submit_evars", "Submit"),
#   actionButton("reset_evars", "Reset")
#   #actionButton("delete_evars", "Delete")
#   )
# })

output$ui_eData <- renderUI({
  tagList(
    shinyjs::useShinyjs(),
    wellPanel(
    #checkboxInput("data_pause", "Pause view", state_init("data_pause", FALSE)),
    uiOutput("ui_edata_vars"),
    #uiOutput("ui_evars")
    actionButton("submit_evars", "Submit"),
    actionButton("reset_evars", "Reset")
),
help_and_report(modal_title = "Edit Data", fun_name = "eData",
                author = "Karim Mezhoud",
                help_file = inclRmd(file.path(
                 getOption("radiant.path.dose"),"app/tools/help/eData.Rmd")))

#help_modal('EditData','editData_Help',inclMD(file.path(getOption("radiant.path.dose"),"app/tools/help/eData.md")))
  )
})

output$dataEdit <- DT::renderDataTable({

  ## colnames is not updated when data is changed
  ## the displayTable() uses previous colnames
  if (inherits(try( dat <- r_data[[input$dataset]][input$edata_vars], silent=TRUE),"try-error")){
    dat <- r_data[[input$dataset]]
  }else{
    dat <- r_data[[input$dataset]][input$edata_vars]
    #dat <- select_(.getdata(), .dots = input$edata_vars)
  }

  displayTable(dat, session=session)

})

output$editable <- renderUI({
  tagList(
  wellPanel(
    # lapply(1:length(input$edata_vars), function(i) {
    #   div(style="display:inline-block",
    #       h5("Accuracy table:"),
    #       textInput(paste0("input",i), paste0('labal1',i),value = 2,width = "80%")
    #   )}),
    lapply(1:length(input$edata_vars), function(i) {
      div(style="display:inline-block",
        textInput(paste0(input$edata_vars[i],i), label = input$edata_vars[i], "", width= "60%")
      )
    })
  ),

  DT::dataTableOutput("dataEdit")
)
})
