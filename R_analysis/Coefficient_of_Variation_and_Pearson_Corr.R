### Pearson Corr between two tech reps (15hr, 20hr, 25hr, 30hr, 35hr)
```

###Package Info###
#R version 3.3.0
#plyr version 1.8.4

library(plyr)
#This data table is the output from Metaboanalyst after normalization (which includes PQN norm and log transform)
data <- read.csv("Input_files/TechRep_PearsonCorr.csv",header=TRUE)
corTest <- ddply(data, .(grp), summarise, corr=cor.test(X,Y,method="pearson"),name=names(corr))
#To make the summary easier 

corfun<-function(x, y) {
  corr=(cor.test(x, y,
                 alternative="two.sided", method="pearson"))
}

corTest <- ddply(data, .(grp), summarise,z=corfun(X,Y)$statistic, pval=corfun(X,Y)$p.value,r=corfun(X,Y)$estimate, alt=corfun(X,Y)$alternative)

summary(corTest$r)

#Pearson results
    corr       
Min.   :0.9606  
1st Qu.:0.9759  
Median :0.9802  
Mean   :0.9805 
3rd Qu.:0.9880 
Max.   :0.9927


#For some reason, p-val doesn't show but all are < 2.2e-16. As as example

pval <- corfun(data$X[1:977],data$Y[1:977])

	Pearson's product-moment correlation

data:  x and y
t = 112.54, df = 975, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.9588266 0.9678256
sample estimates:
     cor 
0.963598 

```

### Coefficient of variation for QC tech reps 
``` 
#Normalized outputs from MetaboAnalyst
Qc <- read.csv("Input_files/QC_CV.csv",header=TRUE)
Qc2 <-Qc[2:7]
Qc2$testMean <- apply(Qc[,2:7],1, mean)
Qc2$testSD <- apply(Qc[,2:7],1, sd)
Qc2$CV <- (Qc2[,8]/Qc2[,7])*100
summary(Qc2$CV)

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.4538  1.7140  2.6160  2.9550  3.7700 12.1000 



```
### Coefficient of variation for bio reps
```

#Normalized outputs from MetaboAnalyst

data <- read.csv("Input_files/BioReps_CV.csv",header=TRUE)
data$testMean <- apply(data[,3:6],1, mean)
data$testSD <- apply(data[,3:6],1, sd)
data$CV <- (data[,8]/data[,7])*100
tapply(data$CV, data$Descriptor, summary)

#or, for complete summary of all bioreps
summary(data$CV)


output: 
$`15hr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.3787  3.0310  4.0510  4.7590  5.6240 38.2100 

$`20hr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.4181  2.8380  3.9640  4.7350  5.3710 29.2800 

$`25hr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.5442  3.4730  4.9150  5.7070  6.9440 35.5600 

$`30hr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.5674  2.8430  4.2700  5.0510  6.0860 32.5100 

$`35hr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.6969  4.2020  6.0450  7.4110  8.7050 37.6900 

#Summary of all bioreps
  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.3787  3.2010  4.5480  5.5330  6.5790 38.2100

 ```
