### MS 

```
###Package Info###
#R version 3.3.0
#xcms version 1.48.0

library(xcms)
raw <- xcmsRaw(file="XS_5-25_HILIC_35-404.CDF")
setEPS()
postscript("Bactobolin_MS.eps", width=5)
plotEIC(raw,mzrange=c(383,383.1),rtrange=c(200,400))
dev.off()
```

### MSMS

```
library(xcms)
raw <- xcmsRaw(file="XS_6-8-17_00601.CDF")
setEPS()
postscript("Bactobolin_MSMS.eps", width=5)
plotEIC(raw,mzrange=c(312,312.1),rtrange=c(200,400))
dev.off()
```
