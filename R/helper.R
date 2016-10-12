#' Display dataframe in table using DT package
#'
#' @usage displayTable(df, session)
#' @param df a dataframe
#' @param session a session
#'
#' @return A table
#'
#' @examples
#'
#' \dontrun{
#' session <- NULL
#' L3 <- LETTERS[1:3]
#' df <-data.frame(1, 1:10, sample(L3, 10, replace = TRUE))
#' displayTable(df, sesion)
#' }
#'@export
displayTable <-
  function(df, session= session){

    action = DT::dataTableAjax(session, df, rownames = FALSE)
    withProgress(message = 'Generating view table', value = 1,
    #DT::datatable(dat, filter = "top", rownames =FALSE, server = TRUE,
    table <- DT::datatable(df, filter = list(position = "top", clear = FALSE, plain = TRUE),
                           rownames = FALSE, style = "bootstrap", escape = FALSE,
                           class = "compact",
                           selection = "single",
                           options = list(
                             ajax = list(url = action),
                             search = list(search = "",regex = TRUE),
                             columnDefs = list(list(className = 'dt-center', targets = "_all")),
                             autoWidth = TRUE,
                             processing = TRUE,
                             pageLength = 10,
                             lengthMenu = list(c(10, 25, 50, -1), c('10','25','50','All'))
                           )
    )
)
    return(table)

  }
