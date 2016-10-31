## load icon for dosimetry barplot
ld_barplot_dosimetry <- function(){
  options(scipen = 0, digits = 2)
  r_data$ggbarplot_dosimetry

}
## render dosimetry barplot
output$barplot_dosimetry <- renderPlot({
  dat <- r_data[[input$dataset]]

  legendTitle <- as.character(input$data_fill)
  Maxx <-  max(as_ymd(input$periode))
  Minn <- min(as_ymd(input$periode))
  diff <- as.Date(Maxx) - as.Date(Minn)
  ifelse(diff == 0, c(diff <- 90, Minn <- Maxx - 90), diff)
  Title <- paste0( diff, ' Days ', ': from ', Minn , ' to ', Maxx)

  ## filter Date range
  tmp <- dat[dat$Date %in% as_ymd(input$periode),]

  if(input$split_dosimetry == 'All'){

  }else{
    ## split by factors in columns
    filter <- names(which(apply(tmp, 2, function(x) any(grepl(input$split_dosimetry, x)))))
    tmp <- split(tmp, tmp[[filter]], drop=TRUE)[[input$split_dosimetry]]
  }

  ##  omit fill color option
  if(input$data_fill == 'NA'){
    ggbarplot_dosimetry <- ggplot(tmp, aes_string(x = input$data_xvar, y = input$data_yvar)) +
      geom_bar(stat="identity")+
      #geom_hline(aes(yintercept= median(tmp[, input$data_yvar]))) +
      labs(title = Title, fill = legendTitle ) +
      theme(legend.title = element_text( colour="black",
                                         size=14,
                                         face="bold"),
            title = element_text( size = 15,
                                  face = 'bold'
            ),
            text = element_text(size = 14,
                                face= 'bold'
            ),
            axis.text.x=element_text(angle=45, hjust=1)
      )
  }else{
    ggbarplot_dosimetry <- ggplot(tmp, aes_string(x = input$data_xvar, y = input$data_yvar)) +
      geom_bar(stat="identity", aes(fill = tmp[[as.character(input$data_fill)]]
      )
      )+
      #geom_hline(aes(yintercept= median(tmp[, input$data_yvar]))) +
      labs(title = Title, fill = legendTitle ) +
      theme(legend.title = element_text( colour="black",
                                         size=14,
                                         face="bold"),
            title = element_text( size = 15,
                                  face = 'bold'
            ),
            text = element_text(size = 14,
                                face= 'bold'
            ),
            axis.text.x=element_text(angle=45, hjust=1)
      )
  }

  # guides(fill=guide_legend(title= dat[[input$data_fill]] )) +
  # scale_fill_discrete(name = dat[[input$data_fill]])
  r_data[['ggbarplot_dosimetry']] <- ggbarplot_dosimetry
  ggbarplot_dosimetry
})

## load icon for dosimetry scatter plot
ld_scatterplot_dosimetry <- function(){
  options(scipen = 0, digits = 2)
  r_data$ggscatterplot_dosimetry
}

## render dosimetry scatter plot
output$scatterplot_dosimetry <- renderPlot({
  dat <-  r_data[[input$dataset]]
  #Size <<- sizeVar(input$data_yvar)
  ## filter Date range
  tmp <- dat[dat$Date %in% as_ymd(input$periode),]
  ggscatterplot_dosimetry <- ggplot(tmp, aes_string(x = input$data_xvar, y = input$data_yvar)) +
    #geom_hline(aes(yintercept= median(tmp[, input$data_yvar]))) +
    geom_point(aes(colour = Name, size =  DCE), na.rm = TRUE) +
    labs(size= 'Size') +
    theme(legend.title = element_text( colour="black",
                                       size=14,
                                       face="bold"),
          title = element_text( size = 15,
                                face = 'bold'
          ),
          text = element_text(size = 14,
                              face= 'bold'
          ),
          axis.text.x=element_text(angle=45, hjust=1)
    )

  r_data[['ggscatterplot_dosimetry']] <- ggscatterplot_dosimetry
  ggscatterplot_dosimetry
})



# output$plot_dosimetrySum <- renderPlot({
#   dat <-  r_data[[input$dataset]]
#   tmp <- dat[dat$Date %in% as_ymd(input$periode),]
#   ## Sum DCE and DP by first name and name  (http://stackoverflow.com/questions/7615922/aggregate-r-sum)
#   df_Sum <- aggregate(tmp[ , c("DCE","DP")], by= list(tmp$First.name, tmp$Name) , "sum")
#   colnames(df_Sum) <- c("First.name", "Name", "DCE", "DP")
#   ggplot(df_Sum, aes_string(x = 'Name', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Name))
# })

output$plot_dosimetryBis <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periode),]
  ggplot(tmp, aes_string(x = 'Name', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Date), na.rm = TRUE) #+ geom_jitter()
})



output$plot_Department_Name <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periode),]
  ggplot(tmp, aes_string(x = 'Department', y = input$data_yvar)) + geom_bar(stat="identity",aes(fill = Name))
})

output$plot_Department_Date <- renderPlot({
  dat <-  r_data[[input$dataset]]
  tmp <- dat[dat$Date %in% as_ymd(input$periode),]
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

# output$brush_info <- renderPrint({
#   shiny::brushedPoints(r_data[[input$dataset]], input$plot_dosimetry_brush)
# })


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
