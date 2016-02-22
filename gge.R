#tidying the ghg emissions dataset

gge<-read.table("env_air_gge.tsv", sep="\t", header=TRUE,strip.white=TRUE, na.strings=":")
library(tidyr)
gge<-separate(gge,unit.airpol.airemsect.geo.time, c("unit","airpol","sect","geo"),sep=",")
gge$geo[gge$geo=="UK"]<-"GB"
gge$geo<-gsub("EL","GR",gge$geo)
names(gge)[5:33]<-c(2013:1985)
library(reshape)
gge<-melt(gge,id=c("unit","airpol","sect","geo"))
library(dplyr)
years<-c(1990:2013)
gge_tot<-gge%>%
        rename(year=variable)%>%
        rename(emissions=value)%>%
        group_by(geo,year)%>%
        summarize(tot_ghg=sum(emissions))%>%
        filter(year %in% years,geo!="EU15")

####

#airpollutant dataset
airp<-read.table("env_air_emis.tsv",header=TRUE, sep='\t', na.strings=c("0 n",": z",": "))
airp<-separate(airp,unit.airpol.airsect.geo.time,c("unit","airpol","sect","geo"), sep=",")
airp$geo<-gsub("UK","GB",airp$geo)
airp$geo[airp$geo=="EL"]<-"GR"
names(airp)[5:28]<-c(2013:1990)
airp<-melt(airp,id=c("unit","airpol","sect","geo"))
airp_tot<-airp%>%
        filter(sect=="TOT_NAT")%>%
        rename(year=variable)%>%
        group_by(geo,year)%>%
        summarize(tot_air=sum(value))%>%
        mutate(tot_air=tot_air/1000)
ghg_air<-merge(gge_tot,airp_tot)
ghg_air$year<-as.Date(ghg_air$year,"%Y")

###
#Plot
#select 5 countries
countries<-c("FR","GB","DE","PL","IT","ES")
subdata<-filter(ghg_air,geo %in% countries)
library(googleVis)
m<-gvisMotionChart(subdata, idvar="geo", timevar="year", x="tot_ghg",y="tot_air",options = list(width = 700, height = 500))
plot(m)
