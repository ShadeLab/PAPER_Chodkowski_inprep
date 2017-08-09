### Repeated measures permutational anova

```
###Package info###
#R version 3.3.0
#reshape2 version 1.4.2
#vegan version 2.4-3 
#permute version 0.9-4

require(reshape2)
library(vegan)

data <- read.csv("Input_files/TechRep_PearsonCorr.csv",header=TRUE)
data2 <- rowMeans(data[,4:5])
data3 <- data[,-c(4:5)]
data3$X <- data2
data3 = data3[,-1]
data4 <- dcast(data3, Descriptor ~ Feature, value.var="X")
data5 <- data4[,-1]
rownames(data5) <- data4[,1]
dis <- vegdist(data5, method="euclidean")
map <- read.csv("Input_files/adonis_map.csv",header=TRUE)


```

#Analysis adapted from http://thebiobucket.blogspot.com/2011/04/repeat-measure-adonis-lately-i-had-to.html#more

```
#get R2
print(fit <- adonis(dis~ Time,map, permutations = 1))
B <- 999
# setting up frame which will be populated by random r2 values:
pop <- rep(NA, B + 1)
### the first entry will be the true r2:
pop[1] <- fit$aov.tab[1, 5]

data5$Order<- map$RowOrder
data6 <- data5[order(data5$Order),]
data6 <- data6[,-978]
reps <- gl(4,5)
time <- as.ordered(rep(1:5, 4))

#Turn off mirroring as time should only flow in one direction
ctrl <- how(plots=Plots(strata=reps, type="series"),within=Within(type = "series", mirror = FALSE))

# Number of observations:
nobs <- nrow(data6)

#within in each repeated sample (reps) timepoints are shuffled but the sequence is intact (e.g., for  Rep 1: 1,2,3,4,5 - 5,1,2,3,4 - 4,5,1,2,3 ... etc)

shuffle(nobs, control = ctrl)

set.seed(123)
for(i in 2:(B+1)){
     idx <- shuffle(nobs, control = ctrl)
     fit.rand <- adonis(dist(data6) ~ time[idx],permutations = 1)
     pop[i] <- fit.rand$aov.tab[1, 5]
}

print(pval <- sum(pop >= pop[1]) / (B + 1))

### p-val < 0.01
### r2= 0.758


```

###Which groups are different?

```
library("RVAideMemoire")
pairwise.perm.manova(dis,map$Time,nperm=999,p.method="fdr")

	Pairwise comparisons using permutation MANOVAs on a distance matrix 

data:  betad by map$Time
1999 permutations 

   ft    te    tf    th   
te 0.034 -     -     -    
tf 0.034 0.034 -     -    
th 0.034 0.492 0.034 -    
ty 0.034 0.034 0.034 0.034

P value adjustment method: fdr 

```

#multivariate spread test 
```
groups <- map$Time
mod <- betadisper(dis, groups)
anova(mod)

Output: 
Analysis of Variance Table

Response: Distances
          Df Sum Sq Mean Sq F value  Pr(>F)  
Groups     4 145.19  36.298  2.4318 0.09301 .
Residuals 15 223.90  14.927   

Conclusion: fails to reject the null hypothesis of homogeneous multivariate dispersions
All is well. 
```

###Adonis between bio reps- checking for biological reproducibility
```
#get R2
print(fit <- adonis(dis ~ reps,map, permutations = 1))
#perms
B <- 999
# setting up frame which will be populated by random r2 values:
pop <- rep(NA, B + 1)
### the first entry will be the true r2:
pop[1] <- fit$aov.tab[1, 5]

#reps <- gl(4,5)
reps <- gl(5,4)
#time <- as.ordered(rep(1:5, 4))
time <- as.ordered(rep(1:4, 5))

#Turn off mirroring as time should only flow in one direction
ctrl <- how(plots=Plots(strata=reps, type="series"),within=Within(type = "series", mirror = FALSE))
 
# Number of observations:
nobs <- nrow(data6)

#within in each repeated sample (reps) timepoints are shuffled but the sequence is intact (e.g., for  Rep 1: 1,2,3,4,5 - 5,1,2,3,4 - 4,5,1,2,3 ... etc)

#making progess but need to figure out how to only shuffle one bio rep around per biological rep- meaning, keeping all biorep time points in place besides one. 

shuffle(nobs, control = ctrl)

data7 <- data5[,-978]

set.seed(41)
for(i in 2:(B+1)){
     idx <- shuffle(nobs, control = ctrl)
     fit.rand <- adonis(dist(data7) ~ time[idx],permutations = 1)
     pop[i] <- fit.rand$aov.tab[1, 5]
}

print(pval <- sum(pop >= pop[1]) / (B + 1))
pval < 0.01
r2= 0.122
```



