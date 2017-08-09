```
###Package Info###
#R version 3.3.0
#reshape2 version 1.4.2

library(reshape2)
data <- read.csv("Input_files/Pseudo_Flow_2bioreps.csv", header=TRUE)
data2 <- dcast(data, Hour + Plate ~ Unique,value.var= "Value")
data3 <- data2[,3:12]
data3 <- log(data3,10)
data2 <- data2[,-c(3:12)]
data2[,3:12]= data3
data2$testMean <- apply(data2[,3:12],1, mean,na.rm=TRUE)
data2$testSD <- apply(data2[,3:12],1, sd,na.rm=TRUE)
data2$CV <- (data2[,14]/data2[,13])*100
summary(data2$CV)

  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.8709  1.2040  1.5540  1.5220  1.7610  2.3460 

```
