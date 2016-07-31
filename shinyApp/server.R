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


function(input, output, session) {

  dataset <- reactive({
      paste0(
        countries %>% 
          filter(name == input$countrySelection) %>% 
          extract2("code"),
          "_e.xls"
      ) %>% 
      paste0("www/", .) %>% 
      read_excel(sheet = "Data") %>% 
      set_names(c("Variable", 2005:2014)) ->
      temp
    
      temp %>% 
        select(-Variable) %>% 
        sapply(as.numeric) %>% 
        as.data.frame() %>%  
        mutate(Variable = temp$Variable) %>% 
        extract(c("Variable", as.character(2005:2014))) %>% 
        filter(
          !(is.na(Variable) |
            Variable %in% c(
              "A. Development Finance",
              "B. Trade Cost",
              "C. Trade Performance",
              "D. Development Indicators"
            ))
        )
  })
  
  
  ### option panel
  observe({
    
    input$countrySelection
    input$tabset 

    isolate({
      
      if (input$tabset == "General Information") {
        output$ui_devOptions <- renderUI({NULL})
      } else if (input$tabset == "Show Development") {
        
          output$ui_devOptions <- renderUI({
        
            fluidRow(
              sliderInput(
                "dateRange", "Date Range", min = 2007, max = 2014, step = 1,
                value = c(2007,2014), ticks = FALSE, pre = "year ", sep = ""
              ),
              selectizeInput(
                "variableSelection",
                label = "Variable Selection",
                choices = dataset()$Variable %>% 
                  sort()
              )
              
            )
            
          })
        
      } else if (input$tabset == "Data Table") {
        output$ui_devOptions <- renderUI({NULL})
      } else if (input$tabset == "Compare Country") {
        
        output$ui_devOptions <- renderUI({
          
          fluidRow(
            sliderInput(
              "dateRange", "Date Range", min = 2007, max = 2014, step = 1,
              value = c(2007,2014), ticks = FALSE, pre = "year ", sep = ""
            ),
            selectizeInput(
              "variableSelection",
              label = "Variable Selection",
              choices = dataset()$Variable %>% 
                sort()
            ),
            selectizeInput(
              "compareCountry",
              label = "compare to:",
              choices = countries$name,
              multiple = TRUE,
              options = list(
                maxItems = 15
              )
            )
            
          )
          
        })
        
        
        
      }
    })
  })
  
  # Data Table Output
  output$ui_table <- DT::renderDataTable(
    datatable(dataset()), options = list(
      pageLength = 5,
      initComplete = JS('function(setting, json) { alert("done"); }')
    )
  )
  
  observe({
    
    input$countrySelection
    input$dateRange
    input$variableSelection
    input$compareCountry
    
    isolate({
      
      if (!is.null(input$variableSelection) && !is.null(input$dateRange)) {
        
        # Show Development
        if (input$tabset == "Show Development") {
          output$devGraphic <- renderPlot(
            dataset() %>% 
              extract(
                .$Variable == input$variableSelection,
                as.character(input$dateRange[1]:input$dateRange[2])
              ) %>% 
              melt() %>% 
              set_names(c("year", "unit")) %>% 
              ggplot(data = ., aes(x = year, y = unit)) + 
              geom_bar(stat = "identity", fill = "lightblue") +
              labs(title = input$variableSelection) 
          )
        } else if (input$tabset == "Compare Country") {

          if (!is.null(input$compareCountry)) {
            
            input$compareCountry %>% 
              lapply(function(selCountry) {
                
                paste0(
                  countries %>% 
                    filter(name == selCountry) %>% 
                    extract2("code"),
                  "_e.xls"
                ) %>% 
                  paste0("www/", .) %>% 
                  read_excel(sheet = "Data") %>% 
                  set_names(c("Variable", 2005:2014)) ->
                  temp
                
                temp %>% 
                  select(-Variable) %>% 
                  sapply(as.numeric) %>% 
                  as.data.frame() %>%  
                  mutate(Variable = temp$Variable) %>% 
                  extract(c("Variable", as.character(2005:2014))) %>% 
                  filter(
                    !(is.na(Variable) |
                        Variable %in% c(
                          "A. Development Finance",
                          "B. Trade Cost",
                          "C. Trade Performance",
                          "D. Development Indicators"
                        ))
                  ) %>% 
                  extract(
                    .$Variable == input$variableSelection,
                    as.character(input$dateRange[1]:input$dateRange[2])
                  ) %>% 
                  melt() %>% 
                  set_names(c("year", "unit")) %>% 
                  mutate(
                    country = selCountry
                  )
                
                
              }) %>% 
              bind_rows() ->
            otherCountries
            
            
            
          } else {
            otherCountries <- NULL
          }
          
          dataset() %>% 
            extract(
              .$Variable == input$variableSelection,
              as.character(input$dateRange[1]:input$dateRange[2])
            ) %>% 
            melt() %>% 
            set_names(c("year", "unit")) %>% 
            mutate(
              country = input$countrySelection
            ) %>% 
            bind_rows(
              otherCountries
            ) -> 
              compareData
          
          output$compGraphic <- renderPlot({
            compareData %>% 
              ggplot(data = ., aes(x = year,y =  unit, fill = country)) + 
              geom_bar(stat = "identity") +
              labs(title = input$variableSelection) 
          })
          
          
          
        }
        
       
        
        
        
      }
     
      
    })
  })
  
  
  
}