shinyServer(function(input, output, session) {
  ## source shared functions
  source(file.path(getOption("radiant.path.data"),"app/init.R"),
         encoding = getOption("radiant.encoding"), local = TRUE)
 # source(file.path(getOption("radiant.path.data"),"app/radiant.R"),
  #       encoding = getOption("radiant.encoding"), local = TRUE)
  source(file.path("../app/radiant.R"),
         encoding= getOption("radiant.encoding"), local =TRUE)
  #source("help.R", encoding = getOption("radiant.encoding"), local = TRUE)


  ## source data & app tools from radiant.data
  for (file in list.files(c(file.path(getOption("radiant.path.data"),"app/tools/app"),
                            file.path(getOption("radiant.path.data"),"app/tools/data")),
                          pattern="\\.(r|R)$", full.names = TRUE))
    source(file, encoding = getOption("radiant.encoding"), local = TRUE)

  ## 'sourcing' radiant's package functions in the server.R environment
  if (!"package:radiant.dose" %in% search() &&
      getOption("radiant.path.dose") == "..") {
    ## for shiny-server and development
    for (file in list.files("../../R", pattern="\\.(r|R)$", full.names = TRUE))
      source(file, encoding = getOption("radiant.encoding"), local = TRUE)
  } else {
    ## for use with launcher
    radiant.data::copy_all(radiant.dose)
  }
  print(getOption("radiant.path.dose"))
  ## packages to use for example data
 # options(radiant.example.data = "Dosimetrix")
  # r_example_data = "radiant.data"

  ## source Dosimetrix tools for Dosimetrix app
  for (file in list.files(c("tools/dose"), pattern="\\.(r|R)$", full.names = TRUE))
    source(file, encoding = getOption("radiant.encoding"), local = TRUE)

  ## save state on refresh or browser close
  saveStateOnRefresh(session)
})