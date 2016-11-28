#'  display in table patients with excessive cumulative doses
#'
#' @usage Upper_threshold(dat, rangeDate,Y)
#' @param dat dataframe with dosimetry data (column with Dates are necessary)
#' @param rangeDate A range of date
#' @param Y numeric variable (DCE, DP)
#' @return  table with excessive cumulative doses up to threshold (mSv)
#' @examples
#' \dontrun{
#'  Upper_threshold(dat, rangeDate,Y)
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

  if (is.null(rangeDate)||is.null(sapply(unique(dat$date), grep, rangeDate))) {
    return(
      as.data.frame("Please select  date range. ")
    )
  }else{
    ## filter Date range
    tmp <- dat[dat[[date_Column]] %in% as_ymd(rangeDate),]
    ## needed for silencinf error when dataset is changed. the rande date are not updated.
    if (inherits(try( df_Sum <- aggregate(tmp[ , c("DCE","DP")], by= list(tmp$first.Name, tmp$Name) , "sum", na.rm=TRUE),
                      silent=TRUE),"try-error")){

      df_Sum <-  as.data.frame("Please select  date range. ")

    }else{
      ## Sum DCE and DP by first name and name  (http://stackoverflow.com/questions/7615922/aggregate-r-sum)
      df_Sum <- aggregate(tmp[ , c("DCE","DP")], by= list(tmp$first.Name, tmp$Name) ,
                          function(x){sum(x, na.rm=TRUE)})
      colnames(df_Sum) <- c("first.Name", "Name", "DCE", "DP")
      rownames(df_Sum) <- NULL
      #ifelse(!is.null(rownames(df_Sum)), attributes(df_Sum)$row.names <- NULL)

      thresh <- ifelse(Y == "DCE", 6/365 * diff, 500/365 * diff)
      r_data[['thresh']] <- round(thresh, digits=2)
      df_Sum <- df_Sum[df_Sum[Y] >= thresh,]

      #df_Sum <- df_Sum[!apply(df_Sum == "", 1, all),]
    }

    return(df_Sum)

  }



}
