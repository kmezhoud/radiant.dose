# Select row in table -> show details in inputs
observeEvent(input$dataEdit_rows_selected, {
  if (length(input$dataEdit_rows_selected) > 0) {
    data <- ReadData()[input$dataEdit_rows_selected, ]
    UpdateInputs(r_data[[input$dataset]], session)
  }

})

ReadData <- function() {
  if(!is.null(r_data[[input$dataset]])){
    #if (exists("responses")) {
    r_data[[input$dataset]]
  }
}


UpdateInputs <- function(data, session) {

  for(i in 1:length(input$edata_vars)){

    tmp <-ReadData()[,input$edata_vars[i]][input$dataEdit_rows_selected]
    updateTextInput(session, paste0(input$edata_vars[i],i),
                    value = tmp)
  }
}

## reset selected input$edata_vars to zero
InitData_eVars <- function(session){
  for(i in 1:length(input$edata_vars)){
    tmp <-""
    updateTextInput(session, paste0(input$edata_vars[i],i),
                    value = tmp)

  }
}

# Press "Reset" button -> display empty record
observeEvent(input$reset_evars, {
  InitData_eVars(session)

  ## TODO DESELECT ROWS IN TABLE
})


# Click "Submit" button -> view changes in table
observeEvent(input$submit_evars, {

  if (length(input$edata_vars) == 0) {

  } else if (is.null(input$dataEdit_rows_selected) &&
             length(input$edata_vars) == ncol(r_data[[input$dataset]])
  ){
    ## adding  new row if not selected row in table
    dat <- 0
    for(i in 1:length(input$edata_vars)){
      ## verify value type: integer, factor, numeric, date, character
      if(is.factor(r_data[[input$dataset]][,input$edata_vars[i]])){
        tmp <- as.factor(input[[paste0(input$edata_vars[i],i)]])
      }else if (is.integer(r_data[[input$dataset]][,input$edata_vars[i]])){
        tmp <- as.integer(input[[paste0(input$edata_vars[i],i)]])
      }else if(is.numeric(r_data[[input$dataset]][,input$edata_vars[i]])){
        tmp <- as.numeric(input[[paste0(input$edata_vars[i],i)]])
      }else if (is.Date(r_data[[input$dataset]][,input$edata_vars[i]])){
        ## validate date format
        if(input[[paste0(input$edata_vars[i],i)]] != "" ||
           grepl("[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}", input[[paste0(input$edata_vars[i],i)]]) == FALSE
        ){
          tmp <- Sys.Date()
        }else
          tmp <- format(as.POSIXlt.date( input[[paste0(input$edata_vars[i],i)]]), "%Y-%m-%d")

      }else if(is.character(r_data[[input$dataset]][,input$edata_vars[i]])){
        tmp <- as.character(input[[paste0(input$edata_vars[i],i)]])
      }
      dat <- data.frame(dat,tmp)
    }
    dat <- as.data.frame(dat[-1])
    names(dat) <- input$edata_vars
    r_data[[input$dataset]]  <- rbind.data.frame(r_data[[input$dataset]], dat)

  }else if(!is.null(input$dataEdit_rows_selected)){ ##  make changes in table

    ##  backup values  before row delete and put them in InputText field
    bkp <- unname(r_data[[input$dataset]][input$dataEdit_rows_selected,])

    for(i in 1:length(input$edata_vars)){
      ## verifiy the type of value: integer, Date, factor, numeric, character
      if(is.factor(r_data[[input$dataset]][,input$edata_vars[i]]) &&
         input[[paste0(input$edata_vars[i],i)]] %in%
         r_data[[input$dataset]][,input$edata_vars[i]]
      ){
        r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected] <-
          as.factor(input[[paste0(input$edata_vars[i],i)]])

        InitData_eVars(session)

        updateTextInput(session,
                        paste0(input$edata_vars[i],i),
                        value = ""
        )
      }else if(is.integer(r_data[[input$dataset]][,input$edata_vars[i]]) &&
               input[[paste0(input$edata_vars[i],i)]] != "" &&
               length(grep("[^0-9]", input[[paste0(input$edata_vars[i],i)]]))==0
      ) {
        r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected] <-
          as.integer(input[[paste0(input$edata_vars[i],i)]])

        InitData_eVars(session)

        updateTextInput(session,
                        paste0(input$edata_vars[i],i),
                        value = ""
        )

      }else if(is.numeric(r_data[[input$dataset]][,input$edata_vars[i]]) &&
               input[[paste0(input$edata_vars[i],i)]] != "" &&
               length(grep("[^0-9\\.]", input[[paste0(input$edata_vars[i],i)]]))==0
      ){
        r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected] <-
          as.numeric(input[[paste0(input$edata_vars[i],i)]])

        InitData_eVars(session)

        updateTextInput(session,
                        paste0(input$edata_vars[i],i),
                        value = ""#unique(r_data[[input$dataset]][,input$edata_vars[i]])
        )

      }else if(is.Date(r_data[[input$dataset]][,input$edata_vars[i]]) &&
               input[[paste0(input$edata_vars[i],i)]] != "" &&
               grepl("[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}", input[[paste0(input$edata_vars[i],i)]]) == TRUE
      ){
        r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected] <- #Sys.Date()
          format(as.POSIXlt.date(input[[paste0(input$edata_vars[i],i)]]), "%Y-%m-%d")

        InitData_eVars(session)

        updateTextInput(session,
                        paste0(input$edata_vars[i],i),
                        value = ""
        )
      }else if(input[[paste0(input$edata_vars[i],i)]] == ""){
         ## delete  values
         r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected] <- NA

         updateTextInput(session,
                      paste0(input$edata_vars[i],i),
                        value = bkp[i]
        )
     }else{
        updateTextInput(session,
                        paste0(input$edata_vars[i],i),
                        value = r_data[[input$dataset]][,input$edata_vars[i]][input$dataEdit_rows_selected]
        )
      }
    }
    ## remove empty row
    r_data[[input$dataset]] <-  r_data[[input$dataset]][which( apply( !( apply( r_data[[input$dataset]],1,is.na) ),2,sum)!=0 ),]
  }
  updateSelectInput(session, "dataset", label = "Datasets:",
                    choices = r_data$datasetlist,
                    selected = input$dataset)
}, priority = 1)