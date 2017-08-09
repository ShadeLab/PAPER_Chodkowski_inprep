```

###Package info###
#R version 3.3.0
#ggplot2 version 2.2.1

library(ggplot2)
data <- read.csv("Input_files/PC1vsSampleOrder.csv",header=TRUE)
p <- ggplot(data, aes(Run.Order,PC1 ))
plot <- p + geom_point(aes(color=factor(QC)),size=5) + labs(x="Analysis Order") + theme(text = element_text(size=20),legend.title = element_blank(),legend.position = "bottom",legend.background = element_rect(fill="white",size = 0.5, linetype="solid", colour="black")) + geom_hline(yintercept=0,size=1) + scale_x_continuous(breaks = pretty(data$Run.Order, n = 5)) + scale_y_continuous(breaks = pretty(data$PC1, n = 7))
ggsave("PC1vsRunOrder.eps",plot=plot,device="eps",width=8.7, height = 8.7, dpi=600)
```
