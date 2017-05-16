help_dose <- c("Edit" = "eData.Rmd", "Dosimetry" = "dosimetry.Rmd", "Medical" = "medical.Rmd")
output$help_dose <- reactive(append_help("help_dose", file.path(getOption("radiant.path.dose"),"app/tools/help"), Rmd = TRUE))

observeEvent(input$help_dose_all, {help_switch(input$help_dose_all, "help_dose")})
observeEvent(input$help_dose_none,{help_switch(input$help_dose_none, "help_dose", help_on = FALSE)})

help_dose_panel <- tagList(
  wellPanel(
    HTML("<label>Dose Menu: <i id='help_dose_all' title='Check all' href='#' class='action-button glyphicon glyphicon-ok'></i>
         <i id='help_dose_none' title='Uncheck all' href='#' class='action-button glyphicon glyphicon-remove'></i></label>"),
    checkboxGroupInput("help_dose", NULL, help_dose,
                       selected = state_group("help_dose"), inline = TRUE)
    )
  )


# ## option to change help_about doesn't work -->  /tools/dose/about.R
# output$help_about <- renderUI({
#   file.path(getOption("radiant.path.dose"),"app/tools/help/about.Rmd") %>% inclMD %>% HTML
# })
