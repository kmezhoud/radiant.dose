#'  display dosimetry report
#'
#' @usage dosi_report(dat, rangeDate)
#' @param dat dataframe with dosimetry data (column with Dates are necessary)
#' @param rangeDate A range of date
#'
#' @return  individual table with DCE and DP doses and sum (mSv)
#' @return  Date of next sampling
#'
#' @examples
#' \dontrun{
#' dosi_report(dat, rangeDate)
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

  SUM <- stats::aggregate(dat[ , c("DCE","DP")],
                   by= list(dat$first.Name, dat$Name, dat$Department) ,
                   "sum", na.rm=TRUE)
  colnames(SUM) <- c("first.Name", "Name", "Department", "sum.DCE", "sum.DP" )

  ## NOT WORKING WELL SORT IS A DAAFRAME WITH MATRIX IN COLUMN DCE AND DP
  ## without  specifying date as colname in individual report
   #SORT <- stats::aggregate(dat[ , c("DCE","DP")], by= list(dat$first.Name, dat$Name, dat$Department) , "I") ## Petr PIKAL
   #SORT <- as.data.frame(stats::aggregate(dat[ , c("DCE","DP")],
    #                              by= list(dat$first.Name, dat$Name, dat$Department) ,
     #                            function(d) {unlist(d)})) # by David Winsemius
   ## remove matrice in column DCE and DP
   #colnames(SORT)[1:3] <- c("first.Name", "Name", "Department")

  ## Specify date as colname in individual report
  mdat <- reshape2::melt(dat, measure.vars=c("DCE", 'DP'))
  SORT <- reshape2::dcast(mdat, first.Name +  Name + Department ~ date+variable )

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










