################################
### Code for mass spectral analysis statistics for
### ""
### by JL Chodkowski and A Shade
### Prepared  21 December 2016
### Author: Ashley Shade, Michigan State University; shade.ashley <at> gmail.com
################################

# Before you start
# Make sure you are using the latest version of R (and Rstudio)
# The following packages (and their dependencies) are needed to run the whole analysis
# specmine 1.0
# xcms 1.50.0 (bioconductor)
# MAIT 1.8 (bioconductor)
# genefilter 1.56.0 (bioconductor)
# impute 1.48.0 (bioconductor)
# Rcpp 0.12.8

library(specmine)

# Read in ms data
ms.ds=read.ms.spectra("raw_ms_test/", type="ms-spectra", filename.meta=NULL, prof.method=list(step=0.005),fwhm=30, bw=)
# Read in metadata

###John's XCMS pipeline
library(xcms)
xset <- xcmsSet("raw_ms_test/", method = "centWave", polarity="negative", peakwidth=c(1,7), ppm=30, noise=0, snthresh=5, mzdiff=-0.01, prefilter=c(3,100), mzCenterFun = "wMean", integrate=1, profparam= list(step=0.005), fitgauss=FALSE, verbose.columns=TRUE)
xset2 <- retcor(xset, method="obiwarp", plottype= c("none", "deviation"), distFunc="cor_opt", profStep=0.05)
xset2 <- group(xset2, method="density", bw=5, mzwid=0.025, minfrac=1/2, minsamp=2, max=50)
xset3 <- fillPeaks(xset2)
reporttab <- diffreport(xset3, class1 = levels(sampclass(xset3))[1], class2 = levels(sampclass(xset3))[2], "xcmsResults", metlin = -0.15)
###

###Ashley's XCMS edits UPLC/MS
#keep method=centWave - most appropriate for TOF, keep this but the call is wrong because method is restricted to binning algorithms for peak picking.
#Method/instrument-specific parameters:  ppm, peakwidth
#ppm must be set for machine accuracy - is our machine ppm 30?  There is a consistent warning: "Please try lowering the "ppm" parameter"; link suggests "high resolution" QTof UPLC to be set to 15?
#change peakwidth to be c(5,12) for UPLC chromatagraphy; John manually inspected to determin 1,7 s peak width for our method
#fitgauss= TRUE, just for the trouble shooting to determine peak quality
#remove noise=0 because it contradicts arguments "prefilter" and snthresh
#profparam= list(step=0.005) is for peak picking method "bin" only, not centWave... omit
xraw <- xcmsRaw("raw_ms_test/XS-2015_08_7_013_R1_15_TECHREP1_ESIN01.CDF")
xraw.peaks=findPeaks.centWave(xraw,peakwidth=c(1,7), ppm=15, snthresh=5, mzdiff=-0.01, prefilter=c(3,100), mzCenterFun ="wMean", integrate=1, fitgauss=TRUE, verbose.columns=TRUE)
xset=group(xraw.peaks, method="density")


#plot distributions of outputs
par(mfrow=c(4,6))
for(i in 1:ncol(xraw.peaks)){
  plot(xraw.peaks[,i], ylab=colnames(xraw.peaks)[i], main=colnames(xraw.peaks)[i])
}


