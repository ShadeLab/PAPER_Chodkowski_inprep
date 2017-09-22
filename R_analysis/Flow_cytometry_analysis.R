
###P.syringae analysis

require(ggplot2)

mydata <- read.csv(file="Input_files/Pseudo_Flow_2bioreps.csv", header=TRUE, sep=",")
attach(mydata)
md <- data.frame(mydata)

md
g=ggplot(md, aes(x=as.factor(Hour), y=log10(Value)))+
  geom_boxplot(aes(x=as.factor(Hour), y=log10(Value)))+ 
  geom_jitter(aes(x=as.factor(Hour), y=log10(Value)))+
  facet_grid(.~Plate,)+
  theme_bw(base_size=10)+
  facet_wrap(~Plate,)+
  scale_fill_manual(values = "red")
g + ylim(7,10) + xlab("Time (hrs)") + ylab("log10(Cell Counts)")
g

ggsave(file ="PsCellCounts_twoBioReps.eps", plot = g + ylim(7,10) + xlab("Time (h)") + ylab("log10 (Live cell counts)"), width=17.4, height= 13,units="cm") 

###3 member analysis

require(ggplot2)

mydata <- read.csv(file="Input_files/Flow_Cytometry_3mem.csv", header=TRUE, sep=",")
attach(mydata)
md <- data.frame(mydata)
md$Plate <- factor(md$Plate, levels = c("P. syringae","C. violaceum","B. thailandensis"))
require(ggplot2)

g=ggplot(md, aes(x=as.factor(Hour), y=log10(Value)))+
  geom_boxplot(aes(x=as.factor(Hour), y=log10(Value)))+ 
  geom_jitter(aes(x=as.factor(Hour), y=log10(Value)))+
  facet_grid(.~Plate,)+
  theme_bw(base_size=10)+
  scale_fill_manual(values = "red")
g + ylim(7,10) + xlab("Time (h)") + ylab("log10 (Live cell counts)") 

ggsave(file ="3memCellCounts_twoBioReps.eps", plot = g + ylim(7,10) + xlab("Time (h)") + ylab("log10 (Live cell counts)") + theme(strip.background = element_blank(),strip.text.x = element_blank()), width=17.4, height= 5.35,units="cm")


