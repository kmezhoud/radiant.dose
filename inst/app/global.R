## sourcing from radiant.data
options(radiant.path.data = system.file(package = "radiant.data"))
source(file.path(getOption("radiant.path.data"), "app/global.R"),
       encoding = getOption("radiant.encoding", default = "UTF-8"), local = TRUE)

## option to change theme
options(radiant.nav_ui =
        list(windowTitle = "radiant.dose" ,theme= shinythemes::shinytheme("cerulean") , id = "nav_radiant",
            inverse = TRUE, collapsible = TRUE, tabPanel("Data", withMathJax(), uiOutput("ui_data"))))


## change help menu function
## function to generate help, must be in global because used in ui.R
help_menu <- function(hlp) {
  tagList(
    navbarMenu("", icon = icon("question-circle"),
               tabPanel("Help", uiOutput(hlp), icon = icon("question")),
               tabPanel("Videos", uiOutput("help_videos"), icon = icon("film")),
               tabPanel("About", uiOutput("help_about"), icon = icon("info")),
               tabPanel(tags$a("", href = "http://kmezhoud.github.io/radiant.dose/", target = "_blank",
                               list(icon("globe"), "Radiant docs"))),
               tabPanel(tags$a("", href = "https://github.com/kmezhoud/radiant.dose/issues", target = "_blank",
                               list(icon("github"), "Report issue")))
    ),
    tags$head(
      tags$script(src = "js/session.js"),
      tags$script(src = "js/returnTextAreaBinding.js"),
      tags$script(src = "js/returnTextInputBinding.js"),
      tags$script(src = "js/video_reset.js"),
      tags$script(src = "js/message-handler.js"),
      tags$script(src = "js/run_return.js"),
      # tags$script(src = "js/draggable_modal.js"),
      tags$link(rel = "shortcut icon", href = "imgs/icon.png")
    )
  )
}

## copy-right text
options(radiant.help.cc = "&copy; Karim Mezhoud (2017) <a rel='license' href='http://creativecommons.org/licenses/by-nc-sa/4.0/'
        target='_blank'><img alt='Creative Commons License' style='border-width:0' src ='imgs/80x15.png' /></a></br>")


## set path for package
ifelse (grepl("radiant.dose", getwd()) && file.exists("../../inst") , "..",
        system.file(package = "radiant.dose")) %>%
  options(radiant.path.dose = .)

## loading urls and ui
source("init.R", encoding = getOption("radiant.encoding"), local = TRUE)

## loading functions no longer used by radiant.data
source(file.path(getOption("radiant.path.dose"), "app/radiant_old.R"),
       encoding = getOption("radiant.encoding"), local = TRUE)

# word to login for this session
#Edit_pass <- "foo"
Logged <- FALSE
PASSWORD <- data.frame(Brukernavn = c("withr","admin"),
                       Passord = c("25d55ad283aa400af464c76d713c07ad",
                                   "caf973c16410b87b3a996405f421ec14"))



## session authentified
sessionList <- c("Mezhoud", "Sassi")

## IP authentification
ipList <- c("192.168.1.66", "192.168.13.111","192.168.1.73",
            "192.168.1.2")
