
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyBS)
library(DT)

shinyUI(
  fluidPage(
  tabsetPanel(
    tabPanel(title = "Podstawowe informacje o zbiorze danych:",
                 numericInput("minN", label = "Minimalna ilosc ocen dla filmu:", min = 1, max = 200, value = 100),
                 DT::dataTableOutput("movieInfo")
             ),
    tabPanel(title = "Ocena filmow:",
             textOutput("movieName"),
             tags$head(tags$style("#movieName{
                                 font-size: 40px;
                                 }"
             )),
             sliderInput("rate", label = "Ocena", min = 1, max = 5, value = 3),
             actionButton("ignore", label = "Ignoruj"),
             actionButton("accept", label = "Akceptuj"),
             DT::dataTableOutput("rtDT")
             ),
    
    
    tabPanel(title = "Model rekomendacji:",
             actionButton("CreateRecModel", label = "Buduj model!"),
             DT::dataTableOutput("recsDT"),
             actionButton("renderPDF", "Eksportuj jako pdf"),
             bsModal(id = "expPDF", "Eksportuj jako pdf","renderPDF", size = "large",
                     textInput("userName", label = "Imie i nazwisko"),
                     selectInput("format", label = "Wybierz format", choices = c("PDF","HTML", "WORD"), selected = "PDF"),
                     
                     actionButton("runPDF","Generuj!")
                     )
            )
    
  ))
  
)
