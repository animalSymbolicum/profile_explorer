library(shiny)
library(ggplot2)
library(magrittr)
library(dplyr)
library(reshape2)
library(readxl)
library(DT)

read_excel("www/AfT_Profiles_CountryList.xls") %>% 
  set_names(c("code", "name")) %>% 
  extract(3:64, TRUE) ->
  countries


fluidPage(
  
  titlePanel("Aid-For-Trade Country Profile Explorer"),
  
  sidebarPanel(
  
   fluidRow(selectizeInput(
      "countrySelection",
      label = "Country",
      choices = countries$name
    )),
    
    uiOutput("ui_devOptions")
    
  ),
  
  mainPanel(
    tabsetPanel(
      id = "tabset",
      tabPanel(
        "General Information",
        fluidRow(
          h5("This app is designed to expolore Aid-For-Trade Country Profiles."),
          fluidRow(
            style = "padding-left: 16px;",
            # column(
            #   width = 4,
              h5("The original data can be retrived from:"),
            # ),
            # column(
            #   width = 1,
              a("wto.org", href = "http://stat.wto.org/Home/WSDBHome.aspx", target="_blank"),
            # ),
            # column(
            #   width = 1,
              a("here", href = "http://stat.wto.org/AidForTradeProfiles/AidForTradeProfiles(Excel)_e.zip", target = "_blank")
            # )
          )
          
        ),
        fluidRow(
          tags$iframe(style="height:600px; width:100%", src="AfT_Profiles_ExplanatoryNotes.pdf")
        )
        
      
      ),
      tabPanel(
        "Data Table",
        DT::dataTableOutput(
          "ui_table"
        )
      ),
      tabPanel(
        "Show Development",
        plotOutput("devGraphic")
      ),
      tabPanel(
        "Compare Country",
        plotOutput("compGraphic")
      )
    )

  )
)
