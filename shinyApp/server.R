source("prepareData.R")

library(shiny)
library(shinyBS)
library(DT)
library(CFMLPack)
library(whisker)
library(rmarkdown)


assign("rateData",data_frame(Movie = numeric(0), MovieName = character(0), Rate = numeric(0)), envir = .GlobalEnv)

shinyServer(function(input, output) {

  
  output$movieInfo <- DT::renderDataTable({
    movieData %>% group_by(MovieName) %>% summarise(MeanRating = round(mean(Rating),2), Nobs = n()) %>% filter(Nobs > input$minN)
  })

  
  iter = reactive({
    
    iter = (input$ignore + input$accept) + 1
    return(iter)
  })
  
  output$movieName = renderText({
    movieInfo$MovieName[iter()]
  })
  
  rtData = eventReactive(input$accept,{

    it = iter() -1
    
    rateData = get("rateData", envir = .GlobalEnv)
    
    row = cbind(movieInfo[it, ], Rate = input$rate)
    assign("rateData", rbind(row, rateData), envir = .GlobalEnv)
    get("rateData", envir = .GlobalEnv)
  })
  
  output$rtDT = DT::renderDataTable({rtData()[,-1]})
  
  
  modelRecs = eventReactive(input$CreateRecModel,
  {
    userId = max(trainData[1,])+1
    
    trData = cbind(trainData, rbind(userId, rateData$Movie, rateData$Rate))
    modelPtr = CFMLPack::cf_new(trData)
    recs = cf_get_recs(modelPtr, max(trData[1,]), 10)
    movieInfo[recs+1,]
  })
  
  output$recsDT  = DT::renderDataTable(modelRecs())
  
  observeEvent(input$runPDF,
               {
                 save(rateData, file = "rateData.RData")
                 modelRecs = modelRecs()
                 save(modelRecs, file = "modelRecs.RData")
                 
                 template = readLines("eksIn.Rmd", encoding = "UTF-8")
                 tmpl = whisker.render(template, data = list(name = input$userName, format = tolower(input$format)))
                 
                 con = file("eksOut.Rmd", "w", encoding="UTF-8")
                 cat(tmpl, file = con)
                 close(con)
                 
                 outFile = render("eksOut.Rmd", encoding = "UTF-8", clean = TRUE)
                 
                 
                 shell.exec(outFile)
                 
               })
  
  
})
