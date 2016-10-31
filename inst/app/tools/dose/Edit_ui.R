## verify if the  R session user is allowed
isSession <- reactive({
  ## If is there an authentification support
  !is.null(Sys.info()[['login']]) && Sys.info()[['login']] %in% sessionList
  ## without authentification support
  #is.null(Sys.info()[['login']] || Sys.info()[['login']] %in% adminUsers
})

isIP <- reactive({
  ## all info of system
  # system('ifconfig eth0 | grep -oP "inet addr:\\K\\S+"', intern =TRUE) %in% ipList
  system('ipconfig getifaddr en0', intern=TRUE)  %in% ipList
})


## sidebar menus of Edit Panels
output$ui_Edit <- renderUI({
  tagList(
    #uiOutput("ui_datasets_edit"),
    conditionalPanel("input.tabs_Edit == 'Data'", uiOutput("ui_eData"))
    #conditionalPanel("input.tabs_Edit =='Dosimetry'", uiOutput("ui_dosimetry"))
    #conditionalPanel("input.tabs_Edit == 'Organigram'", uiOutput("ui_organigram"))

  )
})

## output is called from the main radiant.dose ui.R
output$Edit_tabs <- renderUI({

  tabsetPanel( id = "tabs_Edit",
               tabPanel("Data", DT::dataTableOutput("dataEdit"))
               # tabPanel("Perso",  uiOutput("ui_perso")),
               # tabPanel("Medical", DT::dataTableOutput("responses"))
  )
})


output$Edit <- renderUI({
  ## USER SESSION AUTHENTIFICATION

  # if(!isSession()) return(h2( paste0("The session",Sys.info()[['login']], "is not authentified as admin.
  #           Please contact maintainer for access.", sep=":_"), style = "color:red"))

  ##  IP AUTHENTIFICATION

  #if(!isIP()) return(h2(paste0("Your IP", system('ipconfig getifaddr en0', intern=TRUE), "is not list as admin.
#                        Please contact maintainer for access.", sep=":_"), style="color:red"))

  sidebarLayout(

    #####  Sidebar Panels ###
    sidebarPanel(

      shinyjs::hidden(
        div( id = "div_ui_Edit",
             uiOutput("ui_Edit")
        )
      )
    ),

    #####  Main Page ###
    mainPanel(
      tagList(
        tags$head(
           tags$link(rel="stylesheet", type="text/css", href="LoginStyle.css"),
           #tags$script(type="text/javascript", src = "md5.js"),
           #tags$script(type="text/javascript", src = "passwdInputBinding.JS"),
           #tags$script(src= "LoginStyle.css")
           tags$script(src = "md5.js"),
           tags$script(src= "passwdInputBinding.JS")
        ),
        ## Login module;
        div(class = "login",
            uiOutput("uiLogin"),
            textOutput("pass")
        ),

        shinyjs::hidden(
          div(
            id= "div_Edit_tabs",
            uiOutput("Edit_tabs")
          )
        )
      )
    )
  )
})
