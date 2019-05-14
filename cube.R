library(XML)
library(Hmisc)
library(rpivotTable)
data<-xmlParse(file="Turismo_definitivoultimo.xml")
cubes<-xmlToList(data)

for(cube in cubes){
  
  print("------")
  print(cube)
  
}
  
a1<-ldata[1]
a1_1<-a1[[1]][".attrs"][[1]]["name"]


a<-list(a=c(1,2,3),b=c(4,5,6))
a[[1]]
names(a1)
a1_1<-a1[[1]]
c1<-ldata["Cube"]
c1<-ldata$Cube
a2<-ldata[2]
a3<-ldata[3]
a4<-ldata[4]
names(a1[[1]])
names(a2[[1]])
names(a3[[1]])
names(a4[[1]])
length(a1[[1]])
length(a2[[1]])
length(a3[[1]])
length(a4[[1]])
a4
print(list.tree(a1))
datat<-list.tree(a1)
str(a1)
library(rpivotTable)

data(HairEyeColor)
rpivotTable(data = HairEyeColor, rows = "",cols="", vals = "Freq", aggregatorName = "Sum", rendererName = "Table", width="100%", height="400px")

