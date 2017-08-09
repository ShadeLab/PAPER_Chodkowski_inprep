```

###Package Info###
#R verision 3.3.0
#ggplot2 verision 2.2.1

data <-read.csv("Input_files/P_syringae_Gates.csv",header=TRUE)
library(ggplot2)
plot <- ggplot(data, aes(x=log(FL1.H,10),y=log(FL3.H,10)), log10="y",log10="x") + geom_point() + geom_density2d() + ylim(c(3,5))+xlim(c(3,6)) + xlab("FL1") +ylab("FL3") + theme(text = element_text(size=15))
ggsave("P_syringae_Gates.eps",plot=plot,device="eps",width=15,height=15, units="cm",dpi=600)
```
