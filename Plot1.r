#Question1
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(NEI)
Emissions<-aggregate(NEI$Emissions,by=list(NEI$year),FUN=sum)
png("Plot1.png")
plot(Emissions$Group.1,Emissions$x,ylab="Annual PM2.5 Emissions",xlab="Year",type='l')
dev.off()
#Question2
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Baltimore<-subset(NEI,NEI$fips=="24510")
str(Baltimore)
Emissions.Balt<-aggregate(Baltimore$Emissions,by=list(Baltimore$year),FUN=sum)
png("Plot2.png")
plot(Emissions.Balt$Group.1,Emissions.Balt$x,ylab="Annual Baltimore PM2.5 Emissions",xlab="Year",type='l')
dev.off()
#Question3
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Baltimore<-subset(NEI,NEI$fips=="24510")
str(Baltimore)
Emissions.Balt2<-aggregate(Baltimore$Emissions,by=list(Baltimore$year,Baltimore$type),FUN=sum)
str(Emissions.Balt2)
#GGplot2 plotting
library(ggplot2)
png("Plot3.png")
ggplot(data = Emissions.Balt2, aes(x = Group.1, y = x, colour = Group.2)) + geom_line(aes(group = Group.2)) + geom_point() + labs(colour="Emission Type",x="Year",y="Emissions in Baltimore city")
dev.off()
#base plotting
png("Baltimore Emissions by Type.png")
plot(Emissions.Balt2$Group.1[Emissions.Balt2$Group.2=="NON-ROAD"],Emissions.Balt2$x[Emissions.Balt2$Group.2=="NON-ROAD"],xlab="Year",ylab="Emissions",type='b',xlim=range(Emissions.Balt2$Group.1),ylim=range(Emissions.Balt2$x),col="red")
lines(Emissions.Balt2$Group.1[Emissions.Balt2$Group.2=="ON-ROAD"],Emissions.Balt2$x[Emissions.Balt2$Group.2=="ON-ROAD"],xlab="Year",ylab="Emissions",type='b',col="green")
lines(Emissions.Balt2$Group.1[Emissions.Balt2$Group.2=="POINT"],Emissions.Balt2$x[Emissions.Balt2$Group.2=="POINT"],xlab="Year",ylab="Emissions",type='b',col="blue")
lines(Emissions.Balt2$Group.1[Emissions.Balt2$Group.2=="NONPOINT"],Emissions.Balt2$x[Emissions.Balt2$Group.2=="NONPOINT"],xlab="Year",ylab="Emissions",type='b',col="black")
legend("topright", legend=c("NON-ROAD","ON-ROAD","POINT","NONPOINT"), lty=c(1,1,1,1),lwd=c(2.5,2.5,2.5,2.5),col=c("red","green","blue","black"))
dev.off()
#Question4
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
coal.SCC<-subset(SCC,grepl("Coal",EI.Sector)==TRUE)
NEI.Coal<-merge(x = NEI, y = coal.SCC, by = "SCC", all.y=TRUE)
Coal.Emissions<-aggregate(Emissions~year,data=NEI.Coal,FUN=sum)
str(Coal.Emissions)
png("Plot4.png")
plot(Coal.Emissions$year,Coal.Emissions$Emissions,xlab="Year",ylab="Coal based Emissions",type='l')
dev.off()
#Question5
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Baltimore<-subset(NEI,NEI$fips=="24510")
vehicle.SCC<-subset(SCC,grepl("Vehicle",EI.Sector)==TRUE)
Balt.Vehicle<-merge(x = Baltimore, y = vehicle.SCC, by = "SCC", all.y=TRUE)
Balt.Vehicle.Emiss<-aggregate(Emissions~year,data=Balt.Vehicle,FUN=sum)
png("Plot5.png")
plot(Balt.Vehicle.Emiss$year,Balt.Vehicle.Emiss$Emissions,xlab="Year",ylab="Vehicle based Emissions in Baltimore",type='l')
dev.off()

#Question6
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Balt_LA<-subset(NEI,NEI$fips=="24510"|NEI$fips=="06037")
vehicle.SCC<-subset(SCC,grepl("Vehicle",EI.Sector)==TRUE)
Balt.LA.Vehicle<-merge(x = Balt_LA, y = vehicle.SCC, by = "SCC", all.y=TRUE)
Balt.LA.Vehicle$County[Balt.LA.Vehicle$fips=="06037"]<-"LA County"
Balt.LA.Vehicle$County[Balt.LA.Vehicle$fips=="24510"]<-"Baltimore City"
Balt.LA.Vehicle.Emiss<-aggregate(Balt.LA.Vehicle$Emissions,by=list(Balt.LA.Vehicle$year,Balt.LA.Vehicle$County), FUN=sum)
png("Plot6.png")
ggplot(data = Balt.LA.Vehicle.Emiss, aes(x = Group.1, y = x, colour = Group.2)) + geom_line(aes(group = Group.2)) + geom_point() + labs(colour="County",x="Year",y="Emissions from Vehicles")
dev.off()