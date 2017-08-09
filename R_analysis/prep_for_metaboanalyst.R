
### Prepping mzMatch output file for input into MetaboAnalyst

```
###Package info###
#R version 3.3.2
# tidyr verision 0.6.1

library(tidyr)
#load file
features = read.csv("Input_files/Prep_for_MetaboAnalyst.txt", header = TRUE, sep = "\t", check.names = FALSE)

#remove first column 
features <- features[,-1]

#remove duplicated features
features <- features[!duplicated(features[,3]),]

#remove features with a positive pearson corr- QC features that increased in abudance with increasing dilution
features <- features[features$dilcorr<0,]

#read in mapping file
map = read.csv("Input_files/mzmatch_Map.csv",header = TRUE,sep = ",",stringsAsFactors = FALSE)

#make a new column containing retention time and m/z
rtmz <- unite(features, newcol, c(RT,mass), sep="/")
rtmz2 <- rtmz$newcol
rtmz3 <- rtmz[,map$File]

#replace all 0 values with half the minimum value- will allow for log transformation
min_val = min(rtmz3[rtmz3 > 0]/2,na.rm=TRUE)
rtmz3[rtmz3 == 0] <- min_val
rtmz3[is.na(rtmz3)]<- min_val

#combine columns 
df <- cbind(rtmz2,rtmz3)

#Remove features whose average QC value is largest in comparison to the average for each time point. This should not be the case considering QC sample is a mixture of all samples, so a feature in the QC should not be larger than the rest.  
Combine.tech = map[,"Descriptor"]
Combine.tech
tech.out = NULL
for(i in 1:length(Combine.tech)){
  temp = rtmz3[,map[,"Descriptor"]==Combine.tech[i]]
  temps = apply(temp, 1, mean)
  tech.out = cbind(tech.out,temps)
}
colnames(tech.out)= Combine.tech
tech.out <- tech.out[, !duplicated(colnames(tech.out))]
Qcavg <-colnames(tech.out)[max.col(tech.out,ties.method="first")]
Qcavg2 <- Qcavg=="QC"
Qcavg3 <- as.data.frame(Qcavg2)
df <- df[Qcavg3[,1]==FALSE,]

#make new dataframe appending new column containing retention time and m/z and feature intensities

row.names(df)=df[,1]
df = df[,-1]
cn = as.vector(map$Sample)
colnames(df)=cn

#remove QC 1:2, 1:4, 1:8 dilution
df=df[,-c(55:57)]

#remove NC
df=df[,-c(41:48)]

#Export Output
write.csv(df,"Final_featureTable_for_MetaboAnalyst.csv")






