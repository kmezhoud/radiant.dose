## option to change help_about
output$help_about <- renderUI({
  file.path(getOption("radiant.path.dose"),"app/tools/help/about.Rmd") %>% inclMD %>% HTML
})

## option to change help_video
output$help_videos <- renderUI({
  file.path(getOption("radiant.path.dose"),"app/tools/help/tutorials.Rmd") %>% inclMD %>% HTML
})
