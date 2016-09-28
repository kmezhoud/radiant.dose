#' Launch radiant.dose in the default browser
#'
#' @usage radiant.dose(navPanel.Edit=FALSE)
#' @param navPanel.Edit choose panel option
#' @return  web page of bioCancer Shiny App
#' @examples
#' \dontrun{
#' library(Dosimetrix)
#' radiant.dose(navPanel.Edit=FALSE)
#'}
#' @details See \url{https://Dosimetrix.github.io/docs} for documentation and tutorials
#'
#'
#'
#' @export
radiant.dose <- function(navPanel.Edit = FALSE){
  if (!"package:radiant.dose" %in% search())
    if (!require(radiant.dose)) stop("Calling radiant.dose start function but radiant.dose is not installed.")
  if(navPanel.Edit==TRUE){
  #  options(radiant.nav_ui =
   #           list(windowTitle = "Dosimerix", id = "nav_radiant", inverse = TRUE,
    #               collapsible = TRUE,theme= shinythemes::shinytheme("united"),
     #              tabPanel("Data", withMathJax(), uiOutput("ui_data")),
      #             tabPanel("Edit", withMathJax(), uiOutput("ui_edit"))
       #       ))
    runApp(system.file("app", package = "radiant.dose"), launch.browser = TRUE)
  }else{
  #  options(radiant.nav_ui =
   #           list(windowTitle = "Dosimerix", id = "nav_radiant", inverse = TRUE,
    #               collapsible = TRUE,theme= shinythemes::shinytheme("cerulean"),
     #              tabPanel("Data", withMathJax(), uiOutput("ui_data"))
      #        ))
    runApp(system.file("app", package = "radiant.dose"), launch.browser = TRUE)

  }

}
