library(ncdf4)
library(raster)
library(rworldmap)
library(dplyr)
library(plyr)
library(forecast)
library(zoo)

#Reading the volcano data
setwd("C:/users/hac809/Desktop/ALLFED")
Vol_loc<-read.table("volcanoes.csv", h=T,sep=",")

#Reading the harvested Area for Wheat, Maize and Rice
crop<-c("SPAMest_Wheat_","SPAMest_Maize_","SPAMest_Rice_")
cropirr<-c("SPAMest_Wheatirr_","SPAMest_Maizeirr_","SPAMest_Riceirr_")
ArNew<-list()
ArNewi<-list()
ArNewr<-list()
setwd("C:/Users/hac809/Documents/Pughtam-cropozone/Global_evaluation_outputs/Area")
for (j in 1:length(crop)){
  ArNew[[j]]<-list.files(pattern=crop[j])
  ArNew[[j]]<-brick(ArNew[[j]])
  }
newmap<-getMap()
Area<-ArNew[[1]][[50]]+ArNew[[2]][[50]]+ArNew[[3]][[50]]

crop<-c("Wheat","Maize","Rice")
cropR<-c("Ray_Yield_Wheat","Ray_Yield_Maize_","Ray_Yield_Rice_")
crop_rayR<-list()
Prod_ray<-list()
setwd("C:/Users/hac809/Documents/Pughtam-cropozone/Global_evaluation_outputs")
for (j in 1:length(crop)){
  crop_rayR[[j]]<-list.files(pattern=cropR[j])
  crop_rayR[[j]]<-brick(crop_rayR[[j]])
  crop_rayR[[j]]<-crop_rayR[[j]][[41]]
  }
Yield_RayT<-(crop_rayR[[1]]+crop_rayR[[2]]+crop_rayR[[3]])/3
crs(Area)<-"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

Production<-Yield_RayT*Area
newmap<-getMap()
newmap<-spTransform(newmap, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
pal <- colorRampPalette(c("Blue","Red"))
dev.new()
plot(Area,zlim=c(0,400000),xlab="LON",ylab="LAT")
lines(newmap,col="gray")
points(Vol_loc$longitude,Vol_loc$latitude,type="p",col="red",cex=0.5,pch=16)
test<-extract(Area,Vol_loc)
Af_area<-sum(test,na.rm=T)
