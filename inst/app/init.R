
options(Edit_Panel =
          tagList(
            tabPanel("Edit", uiOutput("Edit"))
            )
          )

## set default dataset
init_data <- function() {

  r_data <- reactiveValues()

  df_name <- getOption("radiant.init.data", default = "dosimetry")
  if (file.exists(df_name)) {
    df <- load(df_name) %>% get
    df_name <- basename(df_name) %>% {gsub(paste0(".",tools::file_ext(.)),"",., fixed = TRUE)}
  } else {
    df <- data(list = df_name, package = "radiant.data", envir = environment()) %>% get
  }

  r_data[[df_name]] <- df
  r_data[[paste0(df_name, "_descr")]] <- attr(df, "description")
  r_data$datasetlist <- df_name
  r_data$url <- NULL
  r_data
}
