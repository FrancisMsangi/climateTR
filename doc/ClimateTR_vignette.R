## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",fig.width = 7, fig.height = 5,fig.align = "centre"
)

## ----setup--------------------------------------------------------------------
library(climateTR)
library(terra)
library(rasterVis)
library(RColorBrewer)

## -----------------------------------------------------------------------------
daily <- rast(system.file("/daily/kilosa_rainDaily.tif",package = "climateTR"))
daily

## -----------------------------------------------------------------------------
five_agg<- aggr(daily,agg_type ="days",agg_days =5,temp ="day",start = "2019-01-01",end = "2019-12-31",func = sum)
five_agg

## -----------------------------------------------------------------------------
monthly_agg<-aggr(daily,agg_type ="monthly",temp ="day",start = "2019-01-01",end = "2019-12-31",func = sum)
monthly_agg

blues <- brewer.pal('Blues', n = 9)
myTheme.blues <- rasterTheme(region = c( blues))

levelplot(monthly_agg,par.settings=myTheme.blues,margin=FALSE)

## -----------------------------------------------------------------------------
monthly <- rast(system.file("/monthly/kilosa_rainMonthly.tif",package = "climateTR"))
monthly

## -----------------------------------------------------------------------------
annual_agg<- aggr(monthly,agg_type = "annual",temp = "month",start = "1988-01-01",end = "2018-12-31",func = sum)
names(annual_agg)<-paste0('y',1988:2018)
annual_agg

blues <- brewer.pal('Blues', n = 9)
myTheme.blues <- rasterTheme(region = c( blues))

levelplot(annual_agg,par.settings=myTheme.blues,margin=FALSE)


## -----------------------------------------------------------------------------
OND_agg<- aggr(monthly,agg_type = "season",agg_month =c(10,11,12),temp = "month",start = "1988-01-01",end = "2018-12-31",func = sum)
OND_agg

blues <- brewer.pal('Blues', n = 9)
myTheme.blues <- rasterTheme(region = c( blues))

levelplot(OND_agg,par.settings=myTheme.blues,margin=FALSE)


## -----------------------------------------------------------------------------
OToA_agg<-aggr(monthly,agg_type = "season",temp = "month",agg_month = c(10,11,12,1,2,3,4),start = "1988-01-01",end = "2018-12-31",func = sum)
OToA_agg

blues <- brewer.pal('Blues', n = 9)
myTheme.blues <- rasterTheme(region = c( blues))

levelplot(OToA_agg,par.settings=myTheme.blues,margin=FALSE)

## -----------------------------------------------------------------------------
reg_trend<- trend_rast(annual_agg,method = "regression")
reg_trend

plot(reg_trend)

## -----------------------------------------------------------------------------
mann_trend<-trend_rast(annual_agg,method = "Mann_Kendall")
mann_trend

plot(mann_trend)

