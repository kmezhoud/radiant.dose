options(Edit.nav_ui =
          tagList(
            includeCSS(file.path(getOption("radiant.path.dose"),"app/www/style.css")),
            tabPanel("Edit", uiOutput("Edit")),
            tabPanel("Dosimetry", uiOutput("dosimetry")),
            tabPanel("Medical", uiOutput("medical"))
            )
          )


## set default plots resolution
# plot_width <- function(){
#   if (is.null(input$plot_width)){
#     r_data$plot_width <- 600
#   }else{
#     input$plot_width
#   }
# }
#
# plot_height <- function(){
#   if (is.null(input$plot_height)){
#     r_data$plot_height <- 600
#   }else{ input$plot_height
#   }
# }


# ## set default dataset
# init_data <- function() {
#
#   r_data <- reactiveValues()
#
#   df_name <- getOption("radiant.init.dose", default = "Data")
#   if (file.exists(df_name)) {
#     df <- load(df_name) %>% get
#     df_name <- basename(df_name) %>% {gsub(paste0(".",tools::file_ext(.)),"",., fixed = TRUE)}
#   } else {
#     df <- data(list = df_name, package = "radiant.dose", envir = environment()) %>% get
#   }
#
#   r_data[[df_name]] <- df
#   r_data[[paste0(df_name, "_descr")]] <- attr(df, "description")
#   r_data$datasetlist <- df_name
#   r_data$url <- NULL
#   r_data
# }
## set default dataset
init_data <- function(env = r_data) {
  ## Based on discussion with Joe Cheng: Datasets can change over time
  ## so the data needs to be reactive value so the other reactive
  ## functions and outputs that depend on these datasets will know when
  ## they are changed

  ## Using an environment to assign data
  ## http://adv-r.had.co.nz/Environments.html#explicit-envs

  ## using a reactiveValues list to keep track of relevant app info
  ## that needs to be reactive
  r_data <- reactiveValues()
  r_info <- reactiveValues()

  df_names <- getOption("radiant.init.dose", default = "Data")
  for (dn in df_names) {
    if (file.exists(dn)) {
      df <- load(dn) %>% get()
      dn <- basename(dn) %>%
      {gsub(paste0(".", tools::file_ext(.)), "", ., fixed = TRUE)}
    } else {
      df <- data(list = dn, package = "radiant.dose", envir = environment()) %>% get()
      r_info[[paste0(dn, "_lcmd")]] <- glue::glue('{dn} <- data({dn}, package = "radiant.dose",
                                                  envir = environment()) %>% get()\nregister("{dn}")')
    }
    env[[dn]] <- df
    if (!bindingIsActive(as.symbol(dn), env = env)) {
      makeReactiveBinding(dn, env = env)
    }
    r_info[[paste0(dn, "_descr")]] <- attr(df, "description")
  }
  r_info[["datasetlist"]] <- basename(df_names)
  r_info[["url"]] <- NULL
  r_info
}


