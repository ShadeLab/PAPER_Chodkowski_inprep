## Objective:  Determine a pre-processing pipeline for un-targeted mass spectral data (exometabolomics) to analyze synthetic community data
###Ashley Shade

### 24 Dec 2016
<b>Ashley's notes, resources and updates</b>
* very helpful, recent resource (20 Dec 2016): xcms pre-processing tutorial by [Colin Smith](https://bioconductor.org/packages/devel/bioc/vignettes/xcms/inst/doc/xcmsPreprocess.pdf)
* Peer-reviewed paper and manual for [specmine](http://repositorium.sdum.uminho.pt/bitstream/1822/41509/1/document_33749_1.pdf), an R package to integrate different [mass spec analysis tools](https://cran.r-project.org/web/packages/specmine/specmine.pdf)

John C's original XCMS pipeline - intended to be run in R on the Michigan State HPCC
```
library(xcms)
xset <- xcmsSet("raw_ms_test/", method = "centWave", polarity="negative", peakwidth=c(1,7), ppm=30, noise=0, snthresh=5, mzdiff=-0.01, prefilter=c(3,100), mzCenterFun = "wMean", integrate=1, profparam= list(step=0.005), fitgauss=FALSE, verbose.columns=TRUE)
xset2 <- retcor(xset, method="obiwarp", plottype= c("none", "deviation"), distFunc="cor_opt", profStep=0.05)
xset2 <- group(xset2, method="density", bw=5, mzwid=0.025, minfrac=1/2, minsamp=2, max=50)
xset3 <- fillPeaks(xset2)
reporttab <- diffreport(xset3, class1 = levels(sampclass(xset3))[1], class2 = levels(sampclass(xset3))[2], "xcmsResults", metlin = -0.15)
```
Ashley's notes and draft revisions for John C's R code (line 1 `xcmsSet` command).  Let's break it down, one option at a time.
* `method=centWave` - though this method is most appropriate for our instrument (TOF), the command is wrong because "method" options are restricted to binning algorithms for peak picking, and do not include centWave but also does not return an error/override warning.  I determined this by checking the output of the code, and finding `method="bin"`was returned, which is the default.  I was alerted to this error by the R manual for xcms
* `polarity = "negative"` - this is fine, but unnecessary because it is only needed when both postive and negative analyses are availalbe
* `peakwidth=c(1,7)`- this is a method/instrument specific parameter (Smith 2016). John C. manually inspected some raw to determine 1,7 s peak width for our method, but I wonder if there is a less subjective way to do it.  Perhaps we can look at the distribution of peak widths for our data.
* `ppm=30` - this is another instrument-specific parameter (Smith 2016) and ppm must be set for machine accuracy.   There is a consistent warning when John C's first line is executed: `"Please try lowering the "ppm" parameter"`, suggesting that this is not correct; John C picked this value from somewhere in the literature or an xcms forum post, from where exactly he can't remember.  Smith 2016 suggests that  "high resolution" QTof UPLC to be set to 15, but we should be able to determine this for our instrument by looking at the distribution of ppm for our data.
* ` noise=0` - setting the optional noise parameter is in contradiction to the `snthresh=5` and `prefilter` parameters, which set signal to noise thresholds and intensity filters.  Plus, having it set to zero does not make sense because this wouldn't make any noise adjustments anyway. Omit.  
* `snthresh=5` -  snthresh is the acceptable signal-to-noise ratio, which John set to 5.  He set this after manually inspecting the data, but perhaps it can be better informed by looking at the distribution of the signal to noise ratio from our data.
* `mzdiff=-0.01`- this option allows for overlap between peaks that are called when it is set to a negative value.  John C found this value from the literature, but has been adjusting it and is yet unsatisfied with what the appropriate value should be.  Revisit this later.
* `prefilter=c(3,100)` - this option is asking about variability around consecutive scans of the same peak, and sets a peak intensity threshold over which the peak must pass for a set number of scans.  For example, John thinks that our method has each peak scanned 10 times, and so he's said that a peak is kept if for 3 out of those 10 scans it has an intensity of 100.  I looked at the data and I'm not sure if it is actually 10 scans per peak (scmin and scmax output?), so this has to be double checked
* `mzCenterFun = "wMean",` - this option says to use the weighted mean to determine the center mz of a peak.  I asked John C about this and he suggested that it means weighting those scans that have an intensity over the prefilter value (e.g., 100), but this also needs to be double checked.
* `integrate=1` -from the R manual "integration method. If =1 peak limits are found through descent on the mexican hat filtered data, if =2 the descent is done on the real data. Method 2 is very accurate but prone to noise, while method 1 is more robust to noise but less exact.".  
* `fitgauss=FALSE` - this is an option that John has not used, because it takes extra time to fit the gaussian model to each peak, but I think it should be set to `TRUE` for the trouble shooting to determine peak quality. Evaluate how to use the model fit to quality filter data.
* `profparam= list(step=0.005)` is an option to be set for peak picking method "bin" only, not the method "centWave" that we desire... omit this entirely.
* `verbose.columns=TRUE`- this prints results feature columns regarding the selected options above in front of the feature x sample matrix

Updated code
First, we only read in the raw data so that we can pass that data structure to the right peak-finding algorithm, `findPeaks.centWave`.  I used this test just on one sample that was an experimental sample from 15hrs from the very first SynCom Experiment that Sang-Hoon and Keara executed (for John C's methods paper).  I'm using xcms 1.50.0, installed from bioconductor, and I'm performing trouble shooting on my laptop.

```
xraw <- xcmsRaw("raw_ms_test/XS-2015_08_7_013_R1_15_TECHREP1_ESIN01.CDF")
xraw.peaks=findPeaks.centWave(xraw,peakwidth=c(1,7), ppm=15, snthresh=5, mzdiff=-0.01, prefilter=c(3,100), mzCenterFun ="wMean", integrate=1, fitgauss=TRUE, verbose.columns=TRUE)
```

Output columns with data distributions will help to inform these parameters, with the identity of columns provided directly from the xcms manual.
* `peakwidth=c(1,7)` - we can plot the distributions of peak widths using the rtmin and rtmax output

```
peakwidths=xraw.peaks[,"rtmax"]-xraw.peaks[,"rtmin"]
summary(peakwidths)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
  0.114   1.828   2.286   2.762   2.900 134.300
```
* 
