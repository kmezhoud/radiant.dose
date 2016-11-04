#'  plot dosimetry data
#'
#' @usage dosimetryPlot(df, X, Y, rangeDate, Split, Fill)
#' @param df dataframe woth dosimetry data (column with Dates are necessary)
#' @param X x_variable
#' @param Y y_variable
#' @param rangeDate date or  date range
#' @param Split split dataframe by variable
#' @param Fill fill plots by variable
#' @param Type plot Type ('Bar', 'Scatter')
#' @param ReOrder reorder x axis by y (X,reorder(tmp[[input$data_xvar]],tmp[[input$data_yvar]]))
#' @return  web page of radiant.dose Shiny App
#' @examples
#' \dontrun{
#' library(radiant.dose)
#' dat <- generate data......
#' dosimetryPlot(......)
#'}
#' @details See \url{https://radiant.dose.github.io/docs} for documentation and tutorials
#'
#'
#'
#' @export
dosimetryPlot <- function(df,
                          X,
                          Y,
                          rangeDate,
                          Split= 'All',
                          Fill='NA',
                          Type,
                          ReOrder
){
  dat <- df
  legendTitle <- as.character(Fill)
  Maxx <-  max(as_ymd(rangeDate))
  Minn <- min(as_ymd(rangeDate))
  diff <- as.Date(Maxx) - as.Date(Minn)
  ifelse(diff == 0, c(diff <- 90, Minn <- Maxx - 90), diff)
  Title <- paste0( diff, ' Days ', ': from ', Minn , ' to ', Maxx)
  yLab  <- paste0(input$data_yvar, " (mSv)", sep = " " )
  date_Column <- names(which(sapply(dat, is.Date) ==TRUE))
  ## filter Date range
  tmp <- dat[dat[[date_Column]] %in% as_ymd(rangeDate),]

  ## split by Department
  if(Split == 'All'){

  }else{
    ## Split by factors in columns
    filter <- names(which(apply(tmp, 2, function(x) any(grepl(Split, x)))))
    tmp <- split(tmp, tmp[[filter]], drop=TRUE)[[Split]]
  }

  # set threshold DCE = 6 mSv/year, DP = 500 mSv/year
  threshold <- ifelse(Y == "DCE", 6/365 * diff, 500/365 * diff)

  plot_dosimetry <-
    ggplot(tmp, aes_string(x = ReOrder, y = Y)) +

    geom_hline(aes(yintercept = threshold),
                   #colour="Cat.B"),
               na.rm = TRUE,
               show.legend = FALSE) +

     # geom_hline(aes(yintercept= 20,
     #                colour="Cat. A"),
     #            na.rm = TRUE,
     #            show.legend = FALSE) +

    labs(title = Title, fill = legendTitle, x= X ,size= Y, colour= Fill, y = yLab) +
    theme(legend.title = element_text( colour="black",
                                       size=14,
                                       face="bold"),
          title = element_text( size = 15,
                                face = 'bold'
          ),
          text = element_text(size = 14,
                              face= 'bold'
          ),
          axis.text.x=element_text(angle=45, hjust=1),
          legend.position = "right",
          legend.direction = "vertical"
    ) +
    if(Fill =='NA' && Type == 'Scatter'){
      geom_point(aes(colour = NULL, size =  tmp[[as.character(Y)]]), na.rm = TRUE)
    }else if(Fill == 'NA' && Type == 'Bar'){
      geom_bar(stat="identity")
    }else if(Fill != 'NA' && Type == 'Scatter' ){
      geom_point(aes(colour = tmp[[as.character(input$data_fill)]], size =  tmp[[as.character(input$data_yvar)]]), na.rm = TRUE)
    } else{
      geom_bar(stat="identity", aes(fill = tmp[[as.character(Fill)]]))
    }

  ## bkp ggplot for download

  r_data[[Type]] <- plot_dosimetry
  return(plot_dosimetry)
}

