library(data.table)
#find the 3D files
files<-list.files("input", pattern=".off", recursive = TRUE, full.names = TRUE)

#calculate surface area (SA). AOT variable is the "Area of Triangles" on the input mesh
SA.all<-SA(files[1])

#if heights are not normalized, do it now.
SA.all$z<-SA.all$z-min(SA.all$z)

#we can bin to 10 cm vertical intervals to see the vertical distribution of SA
SA.all$z.bin<-floor(SA.all$z*10)/10

#aggregate to 10 cm bins
SA.ag<-aggregate(AOT~z.bin,FUN='sum',SA.all)

#plot it!
plot(SA.ag, col="white")
lines(SA.ag)
