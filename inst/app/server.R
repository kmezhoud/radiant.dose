## rsync -avz -e "ssh" radiant.dose kmezhoud@46.101.227.144:/srv/shiny-server/
##
## ssh kmezhoud@46.101.227.144
shinyServer(function(input, output, session) {
  ## source shared functions
  source(file.path(getOption("radiant.path.data"),"app/init.R"),
         encoding = getOption("radiant.encoding"), local = TRUE)
  source(file.path(getOption("radiant.path.data"),"app/radiant.R"),
         encoding = getOption("radiant.encoding"), local = TRUE)


  source("help.R", encoding = getOption("radiant.encoding"), local = TRUE)
  ## help ui
  output$help_dose_ui <- renderUI({
    sidebarLayout(
      sidebarPanel(
        help_data_panel,
        help_dose_panel,
        uiOutput("help_text"),
        width = 3
      ),

      mainPanel(
        HTML(paste0("<h2>Select help files to show and search</h2><hr>")),
        htmlOutput("help_data"),
        htmlOutput("help_dose")
      )
    )

  })

  ## source data & app tools from radiant.data
  for (file in list.files(c(file.path(getOption("radiant.path.data"),"app/tools/app"),
                            file.path(getOption("radiant.path.data"),"app/tools/data")),
                          pattern="\\.(r|R)$", full.names = TRUE))
    source(file, encoding = getOption("radiant.encoding"), local = TRUE)


  ## packages to use for example data
  #options(radiant.example.data = "radiant.data") # works
  options(radiant.example.data = "radiant.dose")
  #options("radiant.example.data")

  ## 'sourcing' radiant's package functions in the server.R environment

  if (!"package:radiant.dose" %in% search() &&
      getOption("radiant.path.dose") == "..") {
    ## for shiny-server and development
    for (file in list.files("../../R", pattern="\\.(r|R)$", full.names = TRUE))
      source(file, encoding = getOption("radiant.encoding"), local = TRUE)
  }else {
    ## for use with launcher
    radiant.data::copy_all(radiant.dose)
  }

  ## source tools from radiant.dose app
  for (file in list.files(c("tools/dose"), pattern="\\.(r|R)$", full.names = TRUE))
    source(file, encoding = getOption("radiant.encoding"), local = TRUE)

  ## save state on refresh or browser close
  saveStateOnRefresh(session)

  ## close browser when radiant.dose is stopped
  ## close Rstudio when radiant.dose os stopped
  # session$onSessionEnded(function() {
  #    stopApp()
  #    q("no")
  # })
})
