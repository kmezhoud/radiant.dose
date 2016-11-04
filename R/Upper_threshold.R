#'  plot dosimetry data
#'
#' @usage dosimetryPlot(df, X, Y, rangeDate, Split, Fill)
#' @param df dataframe woth dosimetry data (column with Dates are necessary)
#' @param Type plot Type ('Bar', 'Scatter')

#' @return  web page of radiant.dose Shiny App
#' @examples
#' \dontrun{

#'}
#' @details See \url{https://radiant.dose.github.io/docs} for documentation and tutorials
#'
#'
#'
#' @export
Upper_threshold <- function(dat,
                            rangeDate,
                            Y){

  Maxx <-  max(as_ymd(rangeDate))
  Minn <- min(as_ymd(rangeDate))
  diff <- as.Date(Maxx) - as.Date(Minn)
  ifelse(diff == 0, c(diff <- 90, Minn <- Maxx - 90), diff)

  date_Column <- names(which(sapply(dat, is.Date) ==TRUE))
  ## filter Date range
  tmp <- dat[dat[[date_Column]] %in% as_ymd(rangeDate),]
  ## Sum DCE and DP by first name and name  (http://stackoverflow.com/questions/7615922/aggregate-r-sum)
  df_Sum <- aggregate(tmp[ , c("DCE","DP")], by= list(tmp$first.Name, tmp$Name) , "sum")
  colnames(df_Sum) <- c("first.Name", "Name", "DCE", "DP")
  thresh <- ifelse(Y == "DCE", 6/365 * diff, 500/365 * diff)
  r_data[['thresh']] <- round(thresh, digits=2)
  df_Sum <- df_Sum[df_Sum[Y] >= thresh,]
  return(df_Sum)

}
