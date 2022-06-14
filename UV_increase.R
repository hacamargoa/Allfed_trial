library(ncdf4)
library(raster)
library(rworldmap)
library(dplyr)
library(plyr)

#Script to map the estimation of losses caused by sudden ozone depletion
#for wheat, maize and rice in a scenario of nuclear war, or big solar flare
#Area was calculated in locations_volcano.R

#Reading the estimated yield global gridded data for Maize
  setwd("../")
  Mai_rayR<-brick("Ray_Yield_Maize_newcrops_1970-2010.nc")
  Mai_rayR<-Mai_rayR[[41]]
  Prod_Mai<-Mai_rayR*ArNew[[2]][[50]]
  
#Estimating losses of 8% in tropics and 16% in temperate and polar regions
#only 50% of the cultivars are sensitive to UV-B

#Creating Raster of losses
  Poles<-matrix(data=0.92,110,720)  
  Tropics<-matrix(data=0.96,140,720)  
  Loss<-rbind(Poles,Tropics,Poles)
  lossesM<- raster(ncol=720, nrow=360,xmin=-180,xmax=180,ymin=-90,ymax=90)
  values(lossesM)<-Loss

#Multiplying Prod*losses
  NewProd<-Prod_Mai*lossesM
  plot(Prod_Mai,zlim=c(0,1400000))
  plot(NewProd,zlim=c(0,1400000))
  #Original production (MegaTons)
  Prod_Tot<-aggregate(Prod_Mai,fact=c(720,360),sum)
  Prod<-extract(Prod_Tot,1)/1000000
  
  #New production with higher UV-B (MegaTons)
  NProd_Tot<-aggregate(NewProd,fact=c(720,360),sum)
  NProd<-extract(NProd_Tot,1)/1000000
  
  #Losses (%)
  loss=(1-NProd/Prod)*100
  loss
  