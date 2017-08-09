### mzMatch Analysis

```
#Before R on HPCC
module load GNU/4.4.5
module load OpenMPI/1.4.3
module load Java/jdk1.8.0
export LD_LIBRARY_PATH=${JAVA_HOME}/jre/lib/amd64/server
module load R/3.2.0
```
### In R

```
setwd("/mnt/research/ShadeLab/Chodkowski/MassSpec/old_synthetic_community_data_for_methods_paper/mzmatch_allData")
options(java.parameters = array(c("-XX:-UseGCOverheadLimit","-Xms50g","-Xmx75g","-Xns5g","-Xgc: parallel")))
library("rJava")
.jinit()
require("mzmatch.R")
mzmatch.init(memorysize=2048,version.1=FALSE)
mzmatch.R.Setup(projectFolder=getwd(), samplelist="sample_setup.tsv")

#R packages needed to run the analysis
#mzmatch.R_2.0-13    
#xcms_1.46.0         
#Biobase_2.30.0     
#ProtGenerics_1.2.1  
#BiocGenerics_0.16.1 
#mzR_2.8.1          
#Rcpp_0.12.1         
#rJava_0.9-8    

```

### Peak Picking
```
xseto <- xcmsSet(sampleList$filenames, method='centWave', ppm=18, peakwidth=c(3,8),noise=100,snthresh=1, prefilter=c(0,0),integrate=1, mzdiff=-0.001, verbose.columns=TRUE, fitgauss=TRUE)	
save.image("mzmatch.RData")
```
### Retention Time Correction
```
mzmatch.R.Setup(projectFolder=getwd(), samplelist="sample_setup.tsv", outputfolder="peakml_RTcorr")
xset2<-retcor(xseto, method="obiwarp", profStep=0.01)
save.image("mzmatch.RData")
```
### Convert files to peakML format for mzMatch
```
PeakML.xcms.write.SingleMeasurement(xset=xset2,filename=sampleList$outputfilenames, ppm=18,addscans=0, ApodisationFilter=FALSE, writeRejected=FALSE, nSlaves=1)
```
### Combine files by bioreps and then all files
```
#Note:If desired, CV filtering would be performed on the combination of each biorep. This was not performed here
mzmatch.ipeak.Combine(sampleList=sampleList, v=T, rtwindow=60, combination="biological", ppm=18, nSlaves=1,outputfolder="combined_RTcorr")
INPUTDIR <- "combined_RTcorr/"
FILESf <- dir (INPUTDIR,full.names=TRUE,pattern="\\.peakml$")
mzmatch.ipeak.Combine(i=paste(FILESf,collapse=","), v=T, rtwindow=60, combination="set", ppm=18, o = "final_RTcorr_combined.peakml")

```
### Filter by noise and media blank
```
mzmatch.ipeak.filter.NoiseFilter(i="final_RTcorr_combined.peakml",o="final_RTcorrcombined_noisef.peakml",v=T,codadw=0.8)
PeakML.BlankFilter(filename="final_RTcorrcombined_noisef.peakml", ionisation="negative",outputfile="final_RTcombined_noisef_NCfiltered.peakml",IgnoreIntensity=TRUE,BlankSample="NC")
```
### Fill in gaps of peaks not originally picked
```
PeakML.GapFiller(filename = "final_RTcombined_noisef_NCfiltered.peakml", ionisation = "negative",outputfile = "final_combined_NCfiltered_gapfilled.peakml", ppm = 18, rtwin = 60, nSlaves=1, fillAll=TRUE, Rawpath=NULL)
```

### Simple filter to remove features at beginning and end of chromatographic separation.
```
mzmatch.ipeak.filter.SimpleFilter(i="final_combined_NCfiltered_gapfilled.peakml",o="final_combined_NCfiltered_gapFilled_minmaxRT.peakml",maxretentiontime=1080,minretentiontime=30,v=T)
```

### Perform dilution series filter with QC samples
```
trendSets <- c("QD_1", "QD_2", "QD_4", "QD_8")
PeakML.DilutionTrendFilter (filename="final_combined_NCfiltered_gapFilled_minmaxRT.peakml",ionisation="negative", Rawpath=NULL, trendSets=trendSets,p.value.thr=0.05, outputfile="final_combined_NC_minmaxRT_QCdil_filtered_gapFilled.peakml")
```
### Convert file to text for downstream analysis
```
mzmatch.ipeak.convert.ConvertToText(i="final_combined_NC_minmaxRT_QCdil_filtered_gapFilled.peakml", o= "Prep_for_MetaboAnalyst.txt")
```
