## to avoid 'no visible binding for global variable' NOTE
globalVariables(c("r_data","matches"))

# to avoid 'no visible binding for global variable' NOTE
 # globalVariables(c(".","rnd_number"))

#' radiant.dose
#'
#' @name radiant.dose
#' @docType package
#' @import radiant.data shiny mvtnorm
#' @importFrom dplyr %>% arrange arrange_ desc slice
#' @importFrom methods is
#' @importFrom stats as.formula cor na.omit power.prop.test power.t.test qnorm runif
#' @importFrom import from
#' @importFrom utils write.csv
NULL

#' diamonds prices
#'
#' @details A sample of 3,000 from the diamonds dataset bundeled with ggplot2. Description provided in attr(diamonds,"description")
#' @docType data
#' @keywords datasets
#' @name diamonds
#' @usage data(diamonds)
#' @format A data frame with 3000 rows and 10 variables
NULL

#' dosimetry
#'
#' @details A sample of dosimeter
#' @docType data
#' @keywords datasets
#' @name dosimetry
#' @usage data(dosimetry)
#' @format A data frame
NULL
