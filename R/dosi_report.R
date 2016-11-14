#'  display dosimetry report
#'
#' @usage dosi_report(dat)
#' @param dat dataframe with dosimetry data (column with Dates are necessary)
#'
#' @return  individual table with DCE and DP doses and sum (mSv)
#' @return  Date of next sampling
#'
#' @examples
#' \dontrun{

#'}
#' @details See \url{https://radiant.dose.github.io/docs} for documentation and tutorials
#'
#'
#'
#' @export

dosi_report <- function(dat, rangeDate){

  date_Column <- names(which(sapply(dat, is.Date) ==TRUE))
  ## filter Date range
  dat <- dat[dat[[date_Column]] %in% as_ymd(rangeDate),]

  #head(aggregate(dat[ , c("DCE","DP")], by= list(dat$first.Name, dat$Name, dat$Department) , "list"))

  SUM <- aggregate(dat[ , c("DCE","DP")], by= list(dat$first.Name, dat$Name, dat$Department) , "sum")
  colnames(SUM) <- c("first.Name", "Name", "Department", "sum.DCE", "sum.DP" )
  SORT <- as.data.frame(aggregate(dat[ , c("DCE","DP")], by= list(dat$first.Name, dat$Name, dat$Department) , "sort"))
  colnames(SORT)[1:3] <- c("first.Name", "Name", "Department")

  ## rm matrix into SORT
  SORT <- do.call(data.frame,SORT)

  mirge <- merge(SORT, SUM, by=c('first.Name', 'Name', 'Department'))

  # colName <- c("first.Name", "Name", "Department",
  #              strsplit(format(sort(unique(dat$date)), "%y/%m/%d"), '\t'),
  #              strsplit(format(sort(unique(dat$date)), "%y/%m/%d"), '\t'),
  #              "SUM.DCE", "SUM.DP")
  #
  # colnames(mirge) <- colName

  split_mirge <- split(mirge, rep(1:dim(mirge)[1]))

  return(split_mirge)
}










