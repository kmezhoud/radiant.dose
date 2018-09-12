#' Launch radiant.dose in the default browser
#'
#' @usage radiant.dose(navPanel.Edit=FALSE)
#' @param navPanel.Edit choose panel option
#' @return  web page of bioCancer Shiny App
#' @examples
#' \dontrun{
#' library(radiant.dose)
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

#' Create a launcher and updater for Windows (.bat)
#'
#' @details On Windows a file named 'radiant.dose.bat' and one named 'update_radiant.command will be put on the desktop. Double-click the file to launch radiant.dose or update to the latest version.
#'
#' @examples
#' \dontrun{
#' radiant.dose::win_launcher()
#' }
#'
win_launcher <- function() {

  if (!interactive()) stop("This function can only be used in an interactive R session")

  if (Sys.info()["sysname"] != "Windows")
    return(message("This function is for Windows only. For Mac use the mac_launcher() function"))

  answ <- readline("Do you want to create shortcuts for radiant.dose on your Desktop? (y/n) ")
  if (substr(answ, 1, 1) %in% c("y","Y")) {

    local_dir <- Sys.getenv("R_LIBS_USER")
    if (!file.exists(local_dir)) dir.create(local_dir, recursive = TRUE)

    pt <- file.path(Sys.getenv("HOME") ,"Desktop")
    if (!file.exists(pt))
      pt <- file.path(Sys.getenv("USERPROFILE") ,"Desktop", fsep = "\\")

    if (!file.exists(pt)) {
      pt <- Sys.getenv("HOME")
      message(paste0("The launcher function was unable to find your Desktop. The launcher and update files/icons will be put in the directory: ", pt))
    }

    pt <- normalizePath(pt, winslash = "/")

    fn1 <- file.path(pt, "radiant.dose.bat")
    launch_string <- paste0("\"",Sys.which('R'), "\" -e \"if (!require(radiant.dose)) { install.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose') }; library(radiant.dose); shiny::runApp(system.file('app', package='radiant.dose'), port = 4444, launch.browser = TRUE)\"")
    launch_string
    cat(launch_string, file = fn1, sep = "\n")
    Sys.chmod(fn1, mode = "0755")

    fn2 <- file.path(pt, "update_radiant.dose.bat")
    launch_string <- paste0("\"", Sys.which('R'), "\" -e \"unlink('~/r_sessions/*.rds', force = TRUE); install.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose'); suppressWarnings(update.packages(lib.loc = .libPaths()[1], repos = 'https://github.com/kmezhoud/radiant.dose', ask = FALSE))\"\npause(1000)")
    cat(launch_string, file = fn2,sep = "\n")
    Sys.chmod(fn2, mode = "0755")

    if (file.exists(fn1) && file.exists(fn2))
      message("Done! Look for a file named radiant.dose.bat on your desktop. Double-click it to start Radiant in your default browser. There is also a file called update_radiant.bat you can double click to update the version of Radiant on your computer.\n")
    else
      message("Something went wrong. No shortcuts were created.")
  } else {
    message("No shortcuts were created.\n")
  }
}

#' Create a launcher and updater for Mac (.command)
#'
#' @details On Mac a file named 'radiant.dose.command' and one named 'update_radiant.dose.command' will be put on the desktop. Double-click the file to launch radiant.dose or update to the latest version.
#'"
#'
#' @examples
#' \dontrun{
#' radiant.dose::mac_launcher()
#' }
#'
mac_launcher <- function() {

  if (!interactive()) stop("This function can only be used in an interactive R session")

  if (Sys.info()["sysname"] != "Darwin")
    return(message("This function is for Mac only. For windows use the win_launcher() function"))

  answ <- readline("Do you want to create shortcuts for Radiant on your Desktop? (y/n) ")
  if (substr(answ, 1, 1) %in% c("y","Y")) {

    local_dir <- Sys.getenv("R_LIBS_USER")
    if (!file.exists(local_dir)) dir.create(local_dir, recursive = TRUE)

    fn1 <- paste0("/Users/",Sys.getenv("USER"),"/Desktop/radiant.dose.command")
    launch_string <- paste0("#!/usr/bin/env Rscript\nif (!require(radiant.dose)) {\n  install.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose')\n}\n\nlibrary(radiant.dose)\nshiny::runApp(system.file('app', package='radiant.dose'), port = 4444, launch.browser = TRUE)\n")
    cat(launch_string, file = fn1, sep = "\n")
    Sys.chmod(fn1, mode = "0755")

    fn2 <- paste0("/Users/",Sys.getenv("USER"),"/Desktop/update_radiant.dose.command")
    launch_string <- paste0("#!/usr/bin/env Rscript\nunlink('~/r_sessions/*.rds', force = TRUE)\ninstall.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose')\nsuppressWarnings(update.packages(lib.loc = .libPaths()[1], repos = 'https://github.com/kmezhoud/radiant.dose', ask = FALSE))\nSys.sleep(1000)")
    cat(launch_string, file = fn2, sep= "\n")
    Sys.chmod(fn2, mode = "0755")

    if (file.exists(fn1) && file.exists(fn2))
      message("Done! Look for a file named radiant.dose.command  on your desktop. Double-click it to start radiant.dose in your default browser. There is also a file called update_radiant.dose.command you can double click to update the version of radiant.dose on your computer.\n")
    else
      message("Something went wrong. No shortcuts were created.")

  } else {
    message("No shortcuts were created.\n")
  }
}

#' Create a launcher and updater for Linux (.sh)
#'
#' @details On Linux a file named 'radiant.dose.sh' and one named 'update_radiant.dose.sh' will be put on the desktop. Double-click the file to launch the specified radiant.dose app or update radiant.dose to the latest version
#'
#'
#' @examples
#' \dontrun{
#' radiant.dose::linux_launcher()
#' }
#'
linux_launcher <- function() {

  if (!interactive()) stop("This function can only be used in an interactive R session")

  if (Sys.info()["sysname"] != "Linux")
    return(message("This function is for Linux only. For windows use the win_launcher() function and for mac use the mac_launcher() function"))

  answ <- readline("Do you want to create shortcuts for Radiant on your Desktop? (y/n) ")
  if (substr(answ, 1, 1) %in% c("y","Y")) {

    local_dir <- Sys.getenv("R_LIBS_USER")
    if (!file.exists(local_dir)) dir.create(local_dir, recursive = TRUE)

    fn1 <- paste0(Sys.getenv("HOME"),"/Desktop/radiant.dose.sh")
    launch_string <- paste0("#!/usr/bin/env Rscript\nif (!require(radiant.dose)) {\n  install.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose')\n}\n\nlibrary(radiant.dose)\nshiny::runApp(system.file('app', package='radiant.dose'), port = 4444, launch.browser = TRUE)\n")
    cat(launch_string, file = fn1, sep = "\n")
    Sys.chmod(fn1, mode = "0755")

    fn2 <- paste0(Sys.getenv("HOME"),"/Desktop/update_radiant.dose.sh")
    launch_string <- paste0("#!/usr/bin/env Rscript\nunlink('~/r_sessions/*.rds', force = TRUE)\ninstall.packages('radiant.dose', repos = 'https://github.com/kmezhoud/radiant.dose')\nsuppressWarnings(update.packages(lib.loc = .libPaths()[1], repos = 'https://github.com/kmezhoud/radiant.dose', ask = FALSE))\nSys.sleep(1000)")
    cat(launch_string, file = fn2, sep = "\n")
    Sys.chmod(fn2, mode = "0755")

    if (file.exists(fn1) && file.exists(fn2))
      message("Done! Look for a file named radiant.dose.sh on your desktop. Double-click it to start radiant.dose in your default browser. There is also a file called update_radiant.dose.sh you can double click to update the version of radiant.dose on your computer.\n\nIf the .sh files are opened in a text editor when you double-click them go to File Manager > Edit > Preferences > Behavior and click 'Run executable text files when they are opened'.")
    else
      message("Something went wrong. No shortcuts were created.")

  } else {
    message("No shortcuts were created.\n")
  }
}

#' Create a launcher on the desktop for Windows (.bat), Mac (.command), or Linux (.sh)
#'
#' @details On Windows/Mac/Linux a file named radiant.dose.bat/radiant.dose.command/radiant.dose.sh will be put on the desktop. Double-click the file to launch the specified Radiant app
#'
#' @seealso \code{\link{win_launcher}} to create a shortcut on Windows
#' @seealso \code{\link{mac_launcher}} to create a shortcut on Mac
#' @seealso \code{\link{linux_launcher}} to create a shortcut on Linux
#'
#'
#' @examples
#' \dontrun{
#' radiant.dose::launcher()
#' }
#' @export
launcher <- function() {

  os <- Sys.info()["sysname"]
  if (os == "Darwin")
    mac_launcher()
  else if (os == "Windows")
    win_launcher()
  else if (os == "Linux")
    linux_launcher()
  else
    return(message("This function is not available for your platform."))
}
