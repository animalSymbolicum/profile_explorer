Aid-For-Trade Country Profile Explorer
========================================================
author: Majid 
date: 31st of July
autosize: true




Purpose
========================================================

The Profile Explorer App is aimed as an example to present public data from the 
World-Trade-Organisation (WTO) database.

The WTO provides a bunch of datasets which can be found here: <http://stat.wto.org/Home/WSDBHome.aspx>.

This App uses only the Aid-For-Trade Country Profiles which describes several 
economic related indicators from 62 Countries.

The purpose of the app is to draft a first glimbse of an data product that could 
maybe include much more graphs and datasets from the WTO.

The App can be found under the following link:
<https://animalsymbolicum.shinyapps.io/shinyApp/>


Example Data
========================================================

This is an example from the first 10 rows of the afghanistan profile data.
The data was cleaned and includes 80 variables in a timespan from 2005-2014.


```r
afgData[1:10, 1:3] %>% 
  set_names(c("Afghanistan", "2005", "2006"))
```

```
Source: local data frame [10 x 3]

                                      Afghanistan        2005        2006
                                            (chr)       (chr)       (chr)
1                          A. Development Finance          NA          NA
2    Personal remittances, received (current US$)           …           …
3                                FDI inward flows  271.000000  238.000000
4          Non-concessional flows disbursed (OOF)           …   13.155876
5  Trade-related non-concessional flows disbursed           …   13.155876
6           Official development assistance (ODA)           … 2733.407030
7                   Aid for trade flows disbursed           …  762.388126
8                                              NA          NA          NA
9                             Development finance          NA         ...
10    Gross fixed capital formation (current US$) 1353.421550 1648.388990
```

Development Plot
========================================================
This is in example boxplot also used interectively used in the application. 
It can be used to preview developement of an specific country for a specific indicator.



```
processing file: ProfileExplorerPresentation.Rpres
Quitting from lines 51-76 (ProfileExplorerPresentation.Rpres) 
Fehler in eval(expr, envir, enclos) : konnte Funktion "%>%" nicht finden
Ruft auf: knit ... handle -> withCallingHandlers -> withVisible -> eval -> eval
Ausführung angehalten
```
