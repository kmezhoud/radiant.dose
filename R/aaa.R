## to avoid 'no visible binding for global variable' NOTE
globalVariables(c("r_data","matches", "is.Date", "aggregate","aes_string", "aes", "element_text"))

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

#' dosimetry_CNSTN
#'
#' @details A sample of dosimeter
#' @docType data
#' @keywords datasets
#' @name dosimetry_CNSTN
#' @usage data(dosimetry_CNSTN)
#' @format A data frame
NULL

#' dosimetry_CNRP
#'
#' @details A sample of dosimeter
#' @docType data
#' @keywords datasets
#' @name dosimetry_CNRP
#' @usage data(dosimetry_CNRP)
#' @format A data frame
NULL


#' Medical_CNSTN
#'
#' @details A sample of Medical essays
#' @docType data
#' @keywords datasets
#' @name Medical_CNSTN
#' @usage data(Medical_CNSTN)
#' @format A data frame
NULL

#' Data
#'
#' @details A sample of Medical and dosimetry data
#' @docType data
#' @keywords datasets
#' @name Data
#' @usage data(Data)
#' @format A data frame
NULL
