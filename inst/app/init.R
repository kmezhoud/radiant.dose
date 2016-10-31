options(Edit.nav_ui =
          tagList(
            tabPanel("Edit", uiOutput("Edit")),
            tabPanel("Dosimetry", uiOutput("dosimetry"))
            )
          )

## set default plots resolution
plot_width <- function()
  if (is.null(input$plot_width)) r_data$plot_width else input$plot_width

plot_height <- function()
  if (is.null(input$plot_height)) r_data$plot_height else input$plot_height


## set default dataset
init_data <- function() {

  r_data <- reactiveValues()

  df_name <- getOption("radiant.init.dose", default = "dosimetry")
  if (file.exists(df_name)) {
    df <- load(df_name) %>% get
    df_name <- basename(df_name) %>% {gsub(paste0(".",tools::file_ext(.)),"",., fixed = TRUE)}
  } else {
    df <- data(list = df_name, package = "radiant.dose", envir = environment()) %>% get
  }

  r_data[[df_name]] <- df
  r_data[[paste0(df_name, "_descr")]] <- attr(df, "description")
  r_data$datasetlist <- df_name
  r_data$url <- NULL
  r_data
}


