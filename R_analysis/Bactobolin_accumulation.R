
```
###Package Info###
#R version 3.3.0
#ggplot2 version 2.2.1 

bacto <-read.csv(file="Input_files/Bactobolin_abundance.csv",sep=",",header=TRUE)
library(ggplot2)
bacto_accumulation <- ggplot(bacto, aes(x=Time,y=log(Intensity,base=2),group=Time))+geom_boxplot()+scale_x_continuous(breaks=seq(15,35,5))+scale_y_continuous(breaks=seq(5,20,2.5))+labs(x="Time (hr)", y="log2(MS intensity[a.u.])")
ggsave("Bactobolin_accumulation.eps",plot=bacto_accumulation,device="eps",width=8.7, units="cm",dpi=600)
```
