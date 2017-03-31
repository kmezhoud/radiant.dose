
############



############


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
             imageOutput(imagename)
           })

  do.call(tagList, image_output_list)
})

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
