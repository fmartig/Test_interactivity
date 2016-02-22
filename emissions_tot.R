#Code to produce the emissions_tot data frame
#Contains the Total national emissions (sector) for all countries in a long data frame

emissions<-read.table("env_air_emis.tsv",header=TRUE, sep='\t', na.strings=c("0 n",": z",": "))
library(tidyr)
emissions<-separate(emissions,unit.airpol.airsect.geo.time,c("unit","airpol","sect","geo"), sep=",")
emissions$geo<-gsub("UK","GB",emissions$geo)
emissions$geo[emissions$geo=="EL"]<-"GR"
library(dplyr)
emissions_tot<-emissions%>%
        mutate(airpol=factor(airpol),sect=factor(sect),geo=factor(geo))%>%
        filter(sect=="TOT_NAT")%>%
        select(-1)
names(emissions_tot)[4:27]<-c(2013:1990)
library(reshape)
emissions_tot<-melt(emissions_tot, id=c("airpol","sect","geo"))
emissions_tot<-emissions_tot%>%
        dplyr::rename(year=variable)%>%
        mutate(emission=value/1000)
write.csv(emissions_tot,"emissions_tot.csv",row.names=FALSE)

