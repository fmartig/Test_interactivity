emissions<-read.table("env_air_emis.tsv",header=TRUE, sep='\t', na.strings=c("0 n",": z",": "))
#as.is=c(2:25)
#Need to split first column into 4

library(tidyr)
emissions<-separate(emissions,unit.airpol.airsect.geo.time,c("unit","airpol","sect","locationvar"), sep=",")
#to check all measurements are in tonnes
unique(emissions$unit)

emissions<-mutate(emissions,airpol=factor(airpol),sect=factor(sect),locationvar=factor(locationvar))

