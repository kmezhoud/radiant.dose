## load icon for dosimetry barplot
ld_barplot_dosimetry <- function(){
  options(scipen = 0, digits = 2)
  r_data$ggbarplot_dosimetry

}
## render dosimetry barplot
output$barplot_dosimetry <- renderPlot({
  if (is.null(input$periodeId)) {
    return(
      plot(x = 1, type = 'n',
           main="\nPlease select Date Range from the dropdown menus to create a plot",
           axes = FALSE, xlab = "", ylab = "")
    )
  }

  dosimetryPlot(df = r_data[[input$dataset]],
                X = input$data_xvar,
                Y = input$data_yvar,
                rangeDate = input$periodeId,
                Split= input$split_dosimetry,
                Fill=input$data_fill,
                Type= 'Bar',
                ReOrder= "reorder(tmp[[input$data_xvar]], tmp[[input$data_yvar]])"
  )

})


output$Upper_threshold <- DT::renderDataTable({

  if (is.null(input$periodeId)) {
    return(
    as.data.frame("Please select  date range. ")
    )
  }else{
  DT::datatable(

  caption = HTML(paste0('Cumulative Threshold (mSv/ range date) = ', tags$span(style="color:red",  r_data$thresh))) ,
  Upper_threshold(dat= r_data[[input$dataset]],rangeDate= input$periodeId, Y= input$data_yvar),
  filter = 'top'

  )
  }
})

## load icon for dosimetry scatter plot
ld_scatterplot_dosimetry <- function(){
  options(scipen = 0, digits = 2)
  r_data$ggscatterplot_dosimetry
}

## render dosimetry scatter plot
output$scatterplot_dosimetry <- renderPlot({

  if (is.null(input$periodeId)) {
    return(
      plot(x = 1, type = 'n',
           main="\nPlease select Date Range from the dropdown menus to create a plot",
           axes = FALSE, xlab = "", ylab = "")
    )
  }

  dosimetryPlot(df = r_data[[input$dataset]],
                X = input$data_xvar,
                Y = input$data_yvar,
                rangeDate = input$periodeId,
                Split= input$split_dosimetry,
                Fill = input$data_fill,
                Type = 'Scatter',
                ReOrder = input$data_xvar
  )

  # r_data[['ggscatterplot_dosimetry']] <- ggscatterplot_dosimetry
  # ggscatterplot_dosimetry
})



# output$plot_dosimetrySum <- renderPlot({
#   dat <-  r_data[[input$dataset]]
#   tmp <- dat[dat$date %in% as_ymd(input$periodeId),]
#   ## Sum DCE and DP by first name and name  (http://stackoverflow.com/questions/7615922/aggregate-r-sum)
#   df_Sum <- aggregate(tmp[ , c("DCE","DP")], by= list(tmp$first.Name, tmp$Name) , "sum")
#   colnames(df_Sum) <- c("first.Name", "Name", "DCE", "DP")
#   ggplot(df_Sum, aes_string(x = 'Name', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Name))
# })

output$plot_dosimetryBis <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periodeId),]
  ggplot(tmp, aes_string(x = 'Name', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Date), na.rm = TRUE) #+ geom_jitter()
})



output$plot_Department_Name <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periodeId),]
  ggplot(tmp, aes_string(x = 'Department', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Name))
})

output$plot_Department_Date <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periodeId),]
  ggplot(tmp, aes_string(x = 'Department', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Date))
})

output$plot_dosimetry2 <- renderPlot({
  ggplot(r_data[[input$dataset]], aes_string(x = input$data_xvar, y = 'DP')) + geom_point(aes(colour = Name), na.rm = TRUE) #+ geom_jitter()
})
# output$click_info <- renderPrint({
#   # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
#   # were a base graphics plot, we'd need those.
#   shiny::nearPoints(r_data[[input$dataset]], input$plot_dosimetry_click, addDist = TRUE)
# })

output$brush_info <- renderPrint({
  shiny::brushedPoints(r_data[[input$dataset]], input$plot_dosimetry_brush)
})


output$plot_brushed_points <- DT::renderDataTable({
  dat <- r_data[[input$dataset]]
  # With base graphics, we need to explicitly tell it which variables were
  # used; with ggplot2, we don't.
  #if (input$plot_type == "base")
  # res <- brushedPoints(dat, input$plot_brush, xvar(), yvar())
  #else if (input$plot_type == "ggplot2")
  res <- shiny::brushedPoints(dat, c(input$plot_dosimetry_brush,input$plot_dosimetry_brush ))

  DT::datatable(res)
})

## used for download plot
plot_width_dosimetry <- reactive({
  if (is_empty(input$plot_width_dosimetry)) r_data$plot_width else 1000
})

# used for download plot
plot_height_dosimetry <- reactive({
  if (is_empty(input$plot_height_dosimetry)) {
    r_data$plot_height
  } else {
    #lx <- ifelse (not_available(input$data_xvar) || isTRUE(input$viz_combx), 1, length(input$data_xvar))
    #ly <- ifelse (not_available(input$data_yvar) || input$viz_type %in% c("dist","density") ||
    #               isTRUE(input$viz_comby), 1, length(input$data_yvar))
    #nr <- lx * ly
    #if (nr > 1)
    #(input$plot_height_dosimetry/2) * ceiling(nr / 2)
    #else
    400
  }
})

# .dosimetry <- function(){
#   options(scipen = 0, digits = 2)
#   r_data$ggscatterplot_dosimetry
# }

# plot_inputs <- reactive({
#   viz_args$dataset <- input$dataset
#   viz_args$shiny <- input$shiny
#   vis_args$X <- input$data_xvar
#   vis_args$Y <- input$data_yvar
#   vis_args$rangeDate <- input$periodeId
#   vis_args$split_dosimetry <- input$split_dosimetry
#   vis_args$Fill <- input$data_fill
#   vis_args$dosimetry_typePlot <- input$dosimetry_typePlot
#
#
#   viz_args
# })

observeEvent(input$dosimetry_report, {
  cmd1 <- paste0("```{r fig.width=10.46, fig.height=5.54, dpi =72}\n",
                paste0("r_data$Bar"),"+",
                "\n",
                "theme(axis.text.x=element_text(angle=45, hjust=1),
                 legend.position = 'right',
                 legend.direction = 'vertical'
                 #labs(title = 'Title', fill = 'legendTitle', x= Name ,size= DCE, colour= date, y = DCE)
                )",
                "\n```\n"

  )

  cmd2 <- paste0("```{r fig.width=10.46, fig.height=5.54, dpi =72}\n",
                 paste0("r_data$Scatter"),"+",
                 "\n",
                 "theme(axis.text.x=element_text(angle=45, hjust=1),
                 legend.position = 'right',
                 legend.direction = 'vertical'
                 #labs(title = 'Title', fill = 'legendTitle', x= Name ,size= DCE, colour= date, y = DCE)
                 )",
                 "\n```\n"

  )

  cmd3 <- paste0("```{r}\n",
                 paste0("table <- Upper_threshold(",
                   "dat= r_data[[input$dataset]],",
                   "rangeDate= input$periodeId,",
                   "Y= input$data_yvar)\n"
                   ),
                 "library(knitr)\n",
                 "rownames(table) <- NULL \n",
                 "kable(table, digits=2)",
                 "\n```\n"
                 )


  cmd4 <- paste0("```{r, results='asis', echo=FALSE, size='small'}\n",
                 "library(knitr)\n",
                 "#lapply(list_mirge, knitr::kable)\n",
                 "report <- dosi_report(r_data[[input$dataset]], input$periodeId)\n",
                 "for(i in 1:length(report)){\n",
                 "next_date <- max(as_ymd(input$periodeId)) + 90 \n",
                 "title <-paste0('Next Sampling Date: ', next_date)\n",
                 "print(knitr::kable(report[[i]], row.names= FALSE, caption= title))\n",
                 "}\n\n",
                 "grid::grid.newpage()\n",
                 "\n```\n"

  )
# CMD <- paste0("```{r}\n dosimetryPlot(",
#               "df= r_data[['", input$dataset,
#               "']],\n X =", input$data_xvar,
#               ",\n Y = ", input$data_yvar,
#               ",\n rangeDate= ", input$periodeId,
#               ", \n Split='", input$split_dosimetry,
#               "',\n Fill=", input$data_fill,
#               ",\n Type=", input$dosimetry_typePlot,
#               ",\n ReOrder=", input$data_xvar,
#               ")\n```"
#              )

  #update_report_fun(CMD)
  update_report_fun(cmd1)
  update_report_fun(cmd2)
  update_report_fun(cmd3)
  update_report_fun(cmd4)
})
