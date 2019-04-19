library(XML)
library(Hmisc)
library(rpivotTable)
data<-xmlParse(file="Turismo_definitivoultimo.xml")
print(data)
ldata<-xmlToList(data)
names(ldata)
a1<-ldata[1]
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
str(a1)
library(rpivotTable)

data(HairEyeColor)
rpivotTable(data = HairEyeColor, rows = "",cols="", vals = "Freq", aggregatorName = "Sum", rendererName = "Table", width="100%", height="400px")
