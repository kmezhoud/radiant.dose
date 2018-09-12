######## ## functions that are not longer used by radiant.data ###########

## check if a button was pressed
pressed <- function(x) !is.null(x) && (is.list(x) || x > 0)

## check if a button was NOT pressed
not_pressed <- function(x) !pressed(x)

plot_downloader <- function(plot_name,
                            width = plot_width,
                            height = plot_height,
                            pre = ".plot_",
                            po = "dl_",
                            fname = plot_name) {
  ## link and output name
  lnm <- paste0(po, plot_name)
  ## create an output
  output[[lnm]] <- downloadHandler(
    filename = function() {
      paste0(fname, ".png")
    },
    content = function(file) {
      ## download graphs in higher resolution than shown in GUI (504 dpi)
      pr <- 5
      ## fix for https://github.com/radiant-rstats/radiant/issues/20
      w <- if (any(c("reactiveExpr", "function") %in% class(width))) width() * pr else width * pr
      h <- if (any(c("reactiveExpr", "function") %in% class(height))) height() * pr else height * pr
      plot <- try(get(paste0(pre, plot_name))(), silent = TRUE)
      if (is(plot, "try-error") || is.character(plot) || is.null(plot)) {
        plot <- ggplot() + labs(title = "Plot not available")
        pr <- 1
        w <- h <- 500
      }
      png(file = file, width = w, height = h, res = 96 * pr)
      print(plot)
      dev.off()
    }
  )
  downloadLink(lnm, "", class = "fa fa-download alignright")
}
## Avoid `XQuartz` requirement in radiant.data
## request XQuartz
## see https://github.com/tidyverse/ggplot2/issues/2655
if(!identical(getOption("bitmapType"), "cairo") && isTRUE(capabilities()[["cairo"]])) {
  options(bitmapType = "cairo")
}
