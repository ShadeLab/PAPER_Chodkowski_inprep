```
###Package Info###
#R verision 3.3.0
#ggplot2 version 2.2.1

library(ggplot2)
data <- read.csv("Input_files/PCA.csv",header=TRUE)
p <- ggplot(data, aes(PC1,PC2))
Sample_Type =factor(data$Label)
PCA <- p + geom_point(aes(color=Label),size=5)+ geom_text(aes(label=Name),size=5,nudge_x=0.75,nudge_y=0.5) + labs(x="PC 1: 63.0% variance explained",y="PC 2: 8.3%variance explained") + theme(text = element_text(size=20),legend.title = element_blank(),legend.position = "bottom",legend.background = element_rect(fill="white",size = 0.5, linetype="solid", colour="black")) + guides(colour = guide_legend(override.aes = list(size=5))) + scale_x_continuous(breaks = pretty(data$PC1, n = 7)) + scale_y_continuous(breaks = pretty(data$PC2, n = 7))
ggsave("PCA.eps",plot=PCA,device="eps",width=8.7,height=8.7,dpi=600)
```
