library(ncdf4)
library(raster)
library(rworldmap)
library(dplyr)
library(plyr)

#Script to map the volcanos and harveste areas for wheat, maize and rice
#Reading the volcano data
Vol_loc<-read.table("volcanoes.csv", h=T,sep=",")

#Reading the harvested Area for Wheat, Maize and Rice
crop<-c("SPAMest_Wheat_","SPAMest_Maize_","SPAMest_Rice_")
cropirr<-c("SPAMest_Wheatirr_","SPAMest_Maizeirr_","SPAMest_Riceirr_")
ArNew<-list()
ArNewi<-list()
ArNewr<-list()
setwd("Area")
for (j in 1:length(crop)){
  ArNew[[j]]<-list.files(pattern=crop[j])
  ArNew[[j]]<-brick(ArNew[[j]])
  }
newmap<-getMap()
Area<-ArNew[[1]][[50]]+ArNew[[2]][[50]]+ArNew[[3]][[50]]


newmap<-getMap()
newmap<-spTransform(newmap, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
pal <- colorRampPalette(c("Blue","Red"))
dev.new()
plot(Area,zlim=c(0,400000),xlab="LON",ylab="LAT")
lines(newmap,col="gray")
points(Vol_loc$longitude,Vol_loc$latitude,type="p",col="red",cex=0.5,pch=16)
test<-extract(Area,Vol_loc)
Af_area<-sum(test,na.rm=T)

#Total affected Area (ha)
Af_area

