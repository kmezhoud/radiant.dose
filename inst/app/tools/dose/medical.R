
#### begin display image from file
output$files <- renderTable(input$files)

files <- reactive({
  files <- input$files
  files$datapath <- gsub("\\\\", "/", files$datapath)
  files
})


output$images <- renderUI({
  image_output_list <-
    lapply(seq_along(nrow(files())),
           function(i)
           {
             imagename = paste0("image", i)
             imageOutput(imagename, width = input$zoom_MedicalReport)
           })

  do.call(tagList, image_output_list)
})

## display  Images dowloaded from file
observe({
  for (i in seq_along(nrow(files())))
  {
    local({
      my_i <- i
      imagename = paste0("image", my_i)
      output[[imagename]] <-
        renderImage({
          list(src = files()$datapath[my_i],
               alt = "Image failed to render")
        }, deleteFile = FALSE)
    })
  }
})


#### end display image from file

### begin display path
observeEvent(
  ignoreNULL = TRUE,
  eventExpr = {
    input$directory
  },
  handlerExpr = {
    if (input$directory > 0) {
      # condition prevents handler execution on initial app launch

      path = choose.dir(default = readDirectoryInput(session, 'directory'))
      updateDirectoryInput(session, 'directory', value = path)
    }
  }
)

# output$directory = renderText({
#   readDirectoryInput(session, 'directory')
# })
#
# output$filesPath = renderDataTable({
#   files = list.files(readDirectoryInput(session, 'directory'), full.names = TRUE)
#   data.frame(name = basename(files), file.info(files))
# })

## End display path

## download Image from file
# output$downloadImage <- downloadHandler(
#   filename = "Shinyplot.png",
#   content = function(file) {
#     png(file)
#
#     dev.off()
# })



observeEvent(input$medical_report, {

  cmd4 <- paste0("```{r}\n",
                 "library(knitr)\n",
                 "image_file <- paste(paste0(readDirectoryInput(session, 'directory'), input$periodeId_Med, sep=''),
                                     '/', input$reports_Med ,sep='')\n",
                 #"shiny::img(src= image_file,  width = 360 )",
                 " obj <- lapply(image_file, function(x){shiny::img(src=x,  width = 360)})\n",
                 "shiny::img(obj) \n",
                 "\n```\n")


  update_report_fun(cmd4)

})
